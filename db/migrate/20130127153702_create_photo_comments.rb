class CreatePhotoComments < ActiveRecord::Migration
  def change
    create_table :photo_comments do |t|
      t.integer :photo_id
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
