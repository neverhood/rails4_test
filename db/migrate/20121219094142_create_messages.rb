class CreateMessages < ActiveRecord::Migration
  def up
    create_table :messages do |t|
      t.integer :user_id
      t.integer :interlocutor_id
      t.boolean :read
      t.text    :body
      t.integer :conversation_id

      t.timestamps
    end

    add_index(:messages, :created_at) # we will retrieve the most recent message along with conversation
    add_index(:messages, :conversation_id)


    # A function that groups messages by sequential user_id ( aka what VK.com does in their conversations )
    # Turns out this works ~3 times faster than pure sql technique with row_number()
    # usage: select * FROM message_groups(conversation_id) LIMIT 25
    # The above will return 25 message groups
    execute <<MESSAGE_GROUPS_FUNCTION
      CREATE OR REPLACE FUNCTION message_groups(conv_id int, page int)
        RETURNS TABLE (ids int[]) AS
      $func$
      DECLARE
         _id    int;
         _uid   int;
         _id0   int;                         -- id of last row
         _uid0  int;                         -- user_id of last row
         offset_value int;
      BEGIN
         offset_value := ( page - 1 ) * 100;

         FOR _id, _uid IN
             SELECT id, user_id FROM messages WHERE messages.conversation_id = conv_id ORDER BY id DESC LIMIT 100 OFFSET offset_value -- fetch by 100 messages a time
         LOOP
             IF _uid <> _uid0 THEN
                RETURN QUERY VALUES (ids);   -- output row (never happens after 1 row)
                ids := ARRAY[_id];           -- start new array
             ELSE
                ids := ids || _id;           -- add to array
             END IF;

             _id0  := _id;
             _uid0 := _uid;                  -- remember last row
         END LOOP;

         RETURN QUERY VALUES (ids);          -- output last iteration
      END
      $func$ LANGUAGE plpgsql;
MESSAGE_GROUPS_FUNCTION
  end

  def down
    drop_table :messages

    execute <<DROP_MESSAGE_GROUPS_FUNCTION
      DROP FUNCTION message_groups(conv_id int, page int)
DROP_MESSAGE_GROUPS_FUNCTION
  end
end
