require 'entry_object_type'

class NewsFeedEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry, polymorphic: true

  has_many :subscriptions, foreign_key: 'subscribed_user_id', primary_key: 'user_id'

  scope :for, -> user { joins(:subscriptions).where(['subscriptions.user_id = ?', user.id]).
                          includes(:user).references(:user).
                          order('news_feed_entries.created_at DESC')
  }

  scope :unread, -> { where(read: false) }
end
