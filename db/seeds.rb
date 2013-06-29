# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "#{ Rails.root }/db/seeds/items"

db_configuration = ActiveRecord::Base.configurations[Rails.env]

if Country.count.zero?
  `psql -U #{ db_configuration['username'] } -d #{ db_configuration['database'] } -a -f db/seeds/countries.pg`
end

if City.count.zero?
  `psql -U #{ db_configuration['username'] } -d #{ db_configuration['database'] } -a -f db/seeds/cities.pg`
end

if Region.count.zero?
  `psql -U #{ db_configuration['username'] } -d #{ db_configuration['database'] } -a -f db/seeds/regions.pg`
end
