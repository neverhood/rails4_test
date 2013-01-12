class CreateNewsFeedEntries < ActiveRecord::Migration
  def change
    create_table :news_feed_entries do |t|
      t.integer :entry_id
      t.integer :entry_type
      t.integer :user_id

      t.timestamps
    end

    add_index(:news_feed_entries, :user_id)
  end
end
