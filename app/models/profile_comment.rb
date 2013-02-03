class ProfileComment < ActiveRecord::Base
  include ProfilePostable
  include Feedable
  include Respondable

  # only creates a feed entry if user posts to own profile
  feeds_if -> profile_comment { profile_comment.user_id == profile_comment.profile.user_id }

  validates :body, length: { within: (1..1000) }
end
