require 'active_support/concern'

module ProfilePostable
  extend ActiveSupport::Concern

  included do
    has_one :profile_post, -> post { where(post_type: POLYMORPHIC_INTEGER_TYPES.invert[post.class.name]) }, foreign_key: 'post_id', dependent: :destroy
    belongs_to :user
    belongs_to :profile

    after_create -> post { post.create_profile_post(profile_id: post.profile_id, user_id: post.user_id) }
  end
end
