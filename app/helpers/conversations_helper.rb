module ConversationsHelper
  def conversation_page_header
    names = @interlocutors.map { |interlocutor| interlocutor.name || interlocutor.login }

    page_header t('.with') + ' ' + names.join(', ')
  end
end
