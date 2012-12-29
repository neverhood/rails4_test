require 'message_group'

class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_conversation!, only: [ :show, :destroy  ]

  def destroy
    @conversation.destroy

    respond_with @conversation
  end

  def show
    interlocutor_ids = @conversation.users.tap { |user_ids| user_ids.delete current_user.id }

    @interlocutors = User.where(id: interlocutor_ids).previews
    @message_groups = MessageGroup.for @conversation.id, page

    mark_incoming_messages_as_read!

    respond_to do |format|
      format.html {}
      format.json { render json: { groups: render_to_string(partial: 'conversations/message_group', collection: @message_groups),
                                   last: MessageGroup.last_page?(@conversation.id, page) } }
    end
  end

  def index
    @conversations = current_user.conversations.page(params[:page]).recent
  end

  private

  def conversation_params
    params.require(:conversation).permit(message: [ :interlocutor_id, :body ])
  end

  def find_conversation!
    @conversation = current_user.conversations.where(id: params[:id]).first

    render_not_found! if @conversation.nil?
  end

  def page
    ( params[:page].present? and params[:page].to_i > 1 ) ? params[:page].to_i : 1
  end

  def mark_incoming_messages_as_read!
    incoming_message_ids = @message_groups.map do |message_group|
      message_group.group.select { |message| message.user_id == @interlocutors.first.id }
    end.flatten.map(&:id)

    Message.where(id: incoming_message_ids).update_all(read: true)
  end

end
