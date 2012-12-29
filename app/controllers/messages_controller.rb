require 'message_group'

class MessagesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  before_filter :find_message!, only: [ :destroy ]
  before_filter :find_interlocutor!, only: [ :create ], if: -> { message_params[:conversation_id].nil? }
  before_filter :find_or_initialize_conversation, only: [ :create ]

  def create
    @message = Message.new(message_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @message.valid?
        @conversation = current_user.start_conversation_with(@interlocutor) if @conversation.nil?
        @conversation.append @message

        format.html { redirect_to :back, notice: I18n.t('flash.messages.create.notice') }
        format.json do
          if same_message_group?
            render json: { conversation: { url: conversation_link, id: @conversation.id },
                           message: { body: render_to_string(partial: 'message', locals: { message: @message }), group: false } }
          else
            render json: { conversation: { url: conversation_link, id: @conversation.id },
                           message: { body: render_to_string(partial: 'conversations/message_group', locals: { message_group: MessageGroup.new([@message]) }),
                                                             group: true } }
          end
        end
      else
        format.any { render nothing: true, status: 406 }
      end
    end
  end

  def destroy
    respond_with @message.destroy
  end

  private

  def find_message!
    @message = current_user.messages.where(id: params[:id]).first

    render_not_found! if @message.nil?
  end

  def find_interlocutor!
    @interlocutor = User.where(id: message_params[:interlocutor_id]).first

    render_not_found! if @interlocutor.nil?
  end

  def find_or_initialize_conversation
    @conversation = current_user.conversations.where(id: message_params[:conversation_id]).first
  end

  def message_params
    params.require(:message).permit(:interlocutor_id, :conversation_id, :body)
  end

  def conversation_link
    # needed to render is json response
    view_context.link_to(I18n.t('conversations.to_dialog'), view_context.conversation_path(@conversation), id: 'link-to-conversation')
  end

  def same_message_group?
    Message.where(['id < ?', @message.id]).order('id DESC').limit(1).first.user_id == current_user.id
  end

end
