class City < ActiveRecord::Base
  self.include_root_in_json = false

  belongs_to :country
  belongs_to :region

  default_scope -> { order('cities.id ASC') }
  scope :large, -> { where(large: true) }
end
