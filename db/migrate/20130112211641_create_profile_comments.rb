class CreateProfileComments < ActiveRecord::Migration
  def change
    create_table :profile_comments do |t|
      t.integer :profile_id
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
