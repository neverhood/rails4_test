class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.integer :album_id
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
