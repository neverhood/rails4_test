class ProfileComment < ActiveRecord::Base
  include ProfilePostable

  validates :body, length: { within: (1..1000) }
end
