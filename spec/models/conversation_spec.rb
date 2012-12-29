require 'spec_helper'

describe Conversation do

  let(:conversation) { FactoryGirl.create(:conversation) }

  it { should have_many(:messages) }
  it { should have_one(:last_message) }

  describe '#last_message' do
    it 'retrieves the last conversation message' do
      conversation.last_message.should == conversation.messages.order('messages.created_at DESC').limit(1).first
    end
  end

  describe 'Methods' do
    let(:conversation) { FactoryGirl.create(:standalone_conversation, users: [1,2]) }

    describe '#append_message' do
      it 'appends the message and touches #updated_at' do
        -> { conversation.append FactoryGirl.build(:standalone_message, user_id: 1, interlocutor_id: 2) }.should change(conversation, :updated_at)

        conversation.messages.count.should_not be_zero
      end
    end
  end

end
