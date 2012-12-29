require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user) }

  describe 'Conversational' do

    describe 'Associations' do
      let!(:conversation) { FactoryGirl.create(:conversation, users: [ user.id ]) }

      it 'has_many conversations' do
        user.conversations.should include(conversation)
      end

      it 'destroys conversations upon destroy' do
        user.destroy
        expect( -> { conversation.reload }).to raise_error
      end
    end

    describe 'Methods' do
      let(:interlocutor) { FactoryGirl.create(:user) }
      let(:conversation_attributes) { { users: [ interlocutor.id ] } }

      describe '#build_conversation' do
        it 'builds new conversation' do
          conversation = user.build_conversation conversation_attributes
          conversation.users.sort.should == [ user.id, interlocutor.id ].sort
        end
      end

      describe '#create_conversation' do
        it 'creates new conversation' do
          conversation = user.create_conversation(conversation_attributes)
          conversation.should be_persisted
        end
      end

      describe '#start_conversation_with' do
        it 'creates a new conversation with properly assigned attrs' do
          conversation = user.start_conversation_with(interlocutor)
          conversation.users.sort.should == [ user.id, interlocutor.id ].sort

          conversation.should be_persisted
        end

        it 'won`t start conversation with self' do
          user.start_conversation_with(user, conversation_attributes).should be_nil
        end
      end

      describe '#conversation_with' do
        it 'finds conversation with interlocutor' do
          conversation = FactoryGirl.create(:conversation, users: [ user.id, interlocutor.id ])
          user.conversation_with(interlocutor).should == conversation
        end

        it 'fails to find conversation and returns nil' do
          user.conversation_with(interlocutor).should be_nil
        end
      end

      describe '#has_conversation_with?' do
        it 'returns true if conversation exists' do
          conversation = FactoryGirl.create(:conversation, users: [ user.id, interlocutor.id ])
          user.has_conversation_with?(interlocutor).should be_true
        end

        it 'returns false unless conversation exists' do
          user.has_conversation_with?(interlocutor).should be_false
        end
      end
    end

  end

end
