module MessagesHelper
  def link_to_conversation_with user
    if current_user.has_conversation_with?(user)
      link_to t('conversations.to_dialog'), conversation_path( current_user.conversation_with(user) ), id: 'link-to-conversation'
    end
  end
end
