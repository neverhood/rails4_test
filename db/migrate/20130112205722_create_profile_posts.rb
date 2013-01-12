class CreateProfilePosts < ActiveRecord::Migration
  def change
    create_table :profile_posts do |t|
      t.integer :post_id
      t.integer :post_type
      t.integer :user_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
