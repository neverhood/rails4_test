class CreateCities < ActiveRecord::Migration
  def up
    create_table :cities do |t|
      t.string :name
      t.integer :country_id
      t.integer :region_id

      t.boolean :large, default: false # large city
    end

    add_index :cities, :country_id
    add_index :cities, :region_id
    add_index :cities, :large

    execute 'create index cities_name_trgm_gin on cities using gin (name gin_trgm_ops);'
  end

  def down
    drop_table :cities
  end
end
