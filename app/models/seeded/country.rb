class Country < ActiveRecord::Base
  self.include_root_in_json = false

  has_many :cities, :dependent => :destroy
  has_many :regions, :dependent => :destroy

  scope :general, -> { where(id: (1..20)) }
end
