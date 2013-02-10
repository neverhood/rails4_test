class CreateRegions < ActiveRecord::Migration
  def up
    create_table :regions do |t|
      t.integer :country_id
      t.string :name
    end

    add_index :regions, :country_id
  end

  def down
    drop_table :regions
  end
end
