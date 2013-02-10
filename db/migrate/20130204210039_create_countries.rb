class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries do |t|
      t.string :name
      t.string :english_name
    end

    add_index :countries, :name, unique: true
    add_index :countries, :english_name, unique: true

    execute 'create index countries_name_trgm_gin on countries using gin (name gin_trgm_ops);'
    execute 'create index countries_english_name_trgm_gin on countries using gin (english_name gin_trgm_ops);'
  end

  def down
    drop_table :countries

    # execute 'drop index countries_name_trgm_gin;'
    # execute 'drop index countries_english_name_trgm_gin;'
  end
end
