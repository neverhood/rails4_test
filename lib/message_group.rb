class MessageGroup
  PL_PGSQL_OFFSET_VALUE = 100

  attr_reader :group, :user

  def initialize(group, user = nil)
    @group = group
    @user  = user ? user : self.class.fetch_user(group.first.user_id)
  end

  def read!
    Message.update_all({ read: true }, { id: @group.map(&:id) })
  end

  def self.for conversation_id, page = 1
    return [] if Conversation.where(id: conversation_id).count.zero?
    @query_result = ActiveRecord::Base.connection.execute(query_for conversation_id, page)

    message_groups.any?? message_groups.map { |message_group| new message_group } : []
  end

  def self.last_page?(conversation_id, page)
    not Message.where(conversation_id: conversation_id).offset(page * PL_PGSQL_OFFSET_VALUE).order('id').any?
  end

  private

  def self.message_groups
    # Builds real message records groups using the #id_groups pattern
    messages = fetch_messages!
    id_groups.map { |id_group| messages.select { |message| id_group.include? message.id } }
  end

  def self.users
    # temporary stores message groups author to avoid loading same user more than once
    @users ||= {}
  end

  def self.fetch_messages!
    # Eagerly loads all of the messages retrieved by message_groups PL/PGSQL function
    Message.where(id: ids).order('id ASC').load
  end

  def self.ids
    id_groups.flatten
  end

  def self.id_groups
    # Parses raw postgresql arrays into ruby arrays. Output example: [ [1,2], [3,4], [5] ]
    @query_result.values.flatten.compact.map { |group| group.scan(/\d+/).map(&:to_i) }.reverse
  end

  def self.query_for conversation_id, page
    # builds a query to execute against PL/PGSQL function
    "select * from message_groups(#{conversation_id}, #{page})"
  end

  def self.fetch_user user_id
    users[user_id].present?? users[user_id] : User.previews.where(id: user_id).first.tap { |user| users[user.id] = user }
  end

end
