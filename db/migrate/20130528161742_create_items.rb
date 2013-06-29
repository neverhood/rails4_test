class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.boolean :male, null: false
    end

    add_index :items, :male
  end
end
