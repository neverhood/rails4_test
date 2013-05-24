# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

db_configuration = ActiveRecord::Base.configurations[Rails.env]

%w( countries.pg cities.pg regions.pg ).each do |sql_file|
  `psql -U #{ db_configuration['username'] } -d #{ db_configuration['database'] } -a -f db/seeds/#{sql_file}`
end
