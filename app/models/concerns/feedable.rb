require 'active_support/concern'

module Feedable
  extend ActiveSupport::Concern

  included do
    has_one :news_feed_entry, -> entry { where(entry_type: POLYMORPHIC_INTEGER_TYPES.invert[entry.class.name]) }, foreign_key: 'entry_id', dependent: :destroy

    after_create -> entry { entry.create_news_feed_entry(user_id: entry.user_id) }
  end
end
