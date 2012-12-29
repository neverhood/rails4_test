require 'spec_helper'

describe 'Messages' do

  def populate_form!(selector = 'div#new-message-modal') # bang is there since form gets submited
    within selector do
      fill_in 'message_body', with: message.body
      find('#message_interlocutor_id').set interlocutor.id rescue nil
      find('#message_conversation_id').set conversation.id rescue nil

      click_button I18n.t('conversations.new_message_modal.submit')
    end
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:interlocutor) { FactoryGirl.create(:user) }
  let(:message) { FactoryGirl.build(:standalone_message) }

  before { sign_in user }

  describe 'Profiles Page' do
    context 'new conversation' do
      it 'creates new conversation' do
        visit user_path(interlocutor)
        populate_form!

        user.has_conversation_with?(interlocutor).should be_true
        user.conversation_with(interlocutor).messages.count.should == 1
      end
    end

    context 'existing conversation' do
      before { FactoryGirl.create(:conversation, users: [ user.id, interlocutor.id ]) }

      it 'appends message to conversation' do
        visit user_path(interlocutor)
        populate_form!

        user.conversations.count.should == 1
        user.conversation_with(interlocutor).messages.count.should == 1
      end
    end
  end

  describe 'Conversation Page' do
    let(:conversation) { FactoryGirl.create(:conversation, users: [ user.id, interlocutor.id ]) }

    it 'creates new message' do
      visit conversation_path(conversation)
      populate_form! 'form#new-conversation-message'
      conversation.messages.count.should == 1
    end
  end

end
