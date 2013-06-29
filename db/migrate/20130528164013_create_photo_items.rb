class CreatePhotoItems < ActiveRecord::Migration
  def change
    create_table :photo_items do |t|
      t.integer :photo_id, null: false
      t.integer :item_id, null: false
      t.integer :likes_count, default: 0

      t.boolean :visible, default: true
    end

    add_index :photo_items, :photo_id
    add_index :photo_items, [ :photo_id, :item_id ], unique: true
  end
end
