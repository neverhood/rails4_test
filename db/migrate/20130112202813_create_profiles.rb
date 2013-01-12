class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.hstore :preferences

      t.timestamps
    end

    add_index :profiles, :user_id, unique: true
    execute 'CREATE INDEX profiles_gin_preferences ON profiles USING GIN(preferences);'
  end
end
