class ProfilePost < ActiveRecord::Base
  POST_TYPES = [1] # This is mapped in initializers/polymorphic_integer_types

  belongs_to :post, polymorphic: true
  belongs_to :user
  belongs_to :profile

  default_scope -> { order('profile_posts.created_at DESC') }
end
