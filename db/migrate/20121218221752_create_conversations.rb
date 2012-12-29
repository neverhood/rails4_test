class CreateConversations < ActiveRecord::Migration
  def up
    create_table :conversations do |t|
      t.integer :users, array: true

      t.timestamps
    end

    execute 'CREATE INDEX conversations_gin_users ON conversations USING GIN(users);'
    add_index(:conversations, :updated_at)
  end

  def down
    drop_table :conversations
  end
end
