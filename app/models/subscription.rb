class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscribed_user, class_name: 'User'
end
