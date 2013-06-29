class Item < ActiveRecord::Base
  # This model is static, contents are there in db/seeds

  def self.json
    all.to_json
  end

  scope :male,   -> { where(male: true) }
  scope :female, -> { where(male: false) }
end
