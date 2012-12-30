class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :photos_count, default: 0
      t.string :name
      t.string :transliterated_name
      t.integer :user_id
      t.text :description
      t.integer :conver_photo_id

      t.timestamps
    end

    add_index :albums, :user_id
    add_index :albums, [ :user_id, :transliterated_name ], unique: true
  end
end
