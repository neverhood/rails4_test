class Profile < ActiveRecord::Base
  belongs_to :user

  has_many :profile_posts
end
