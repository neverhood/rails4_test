class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :subscribed_user_id
      t.boolean :confirmed

      t.timestamps
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :subscribed_user_id
  end
end
