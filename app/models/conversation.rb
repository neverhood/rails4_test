class Conversation < ActiveRecord::Base
  has_many :messages, :dependent => :destroy
  has_one  :last_message, -> { order('messages.created_at DESC').limit(1) }, class_name: 'Message'

  scope :recent, -> { order('conversations.updated_at DESC') }

  def append message
    touch(:updated_at) if messages << message.tap { |m| m.conversation_id = id }
  end

  def interlocutor_of user
    User.where(id: users.tap { |user_ids| user_ids.delete user.id }.first).previews.first
  end
end
