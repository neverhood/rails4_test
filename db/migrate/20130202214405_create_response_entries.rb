class CreateResponseEntries < ActiveRecord::Migration
  def change
    create_table :response_entries do |t|
      t.integer :author_id
      t.integer :user_id
      t.integer :entry_id
      t.integer :entry_type
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
