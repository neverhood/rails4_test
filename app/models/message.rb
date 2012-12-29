class Message < ActiveRecord::Base

  belongs_to :conversation
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :author_preview, -> { select('users.id', 'users.avatar', 'users.details', 'users.name', 'users.male') },
    class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'interlocutor_id'


  validates :body, length: { within: (1..5000) }
  # interlocutor_id should be in the list of conversation users
  validates :interlocutor_id, inclusion: { in: :users }, if: -> message { message.conversation_id.present? }
  # interlocutor_id != user_id
  validates :interlocutor_id, exclusion: { in: -> message { Array(message.user_id) } } 


  scope :recent, -> { limit(50).order('messages.created_at ASC') }

  def users
    conversation.users
  end

  def read!
    update_attributes(read: true)
  end
end
