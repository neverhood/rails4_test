module Conversational

  def conversations
    Conversation.where("#{id} = ANY (conversations.users)")
  end

  def conversation_with user
    return nil if id == user.id

    conversations.where("#{user.id} = ANY (conversations.users)").first
  end

  def has_conversation_with? user
    return nil if id == user.id

    conversations.where("#{user.id} = ANY (conversations.users)").any?
  end

  def start_conversation_with user, attributes = {}
    return nil if user.id == id

    create_conversation(attributes.merge(users: [user.id]))
  end

  def create_conversation attributes = {}
    build_conversation(attributes).tap { |conversation| conversation.save }
  end

  def build_conversation attributes = {}
    attributes[:users] << id if attributes[:users].present? and not attributes[:users].include?(id)

    Conversation.new(attributes)
  end

  def self.included(base)
    base.after_destroy -> { self.conversations.destroy_all }
  end

end
