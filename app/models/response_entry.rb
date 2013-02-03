require 'entry_object_type'

class ResponseEntry < ActiveRecord::Base
  # This is basically just a notification entry.
  # For example "User b" comments on photo of "User a". Then the following record will be created:
  # user_id: user_a.id, author_id: user_b.id, entry_id: photo.id, entry_type: photo_integer_key

  belongs_to :user
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :entry, polymorphic: true

  default_scope -> { order('response_entries.created_at DESC') }
  scope :unread, -> { where(read: false) }
end
