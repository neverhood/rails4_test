class UsersSearch < ActiveRecord::Migration
  def up
    execute 'create extension pg_trgm;'
    execute 'create index users_name_trgm_gin on users using gin (name gin_trgm_ops);'
  end

  def down
    execute 'drop extension pg_trgm;'
    execute 'drop index users_name_trgm_gin;'
  end
end
