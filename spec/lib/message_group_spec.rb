require 'spec_helper'
require 'message_group'

describe MessageGroup do

  context 'Without Persisted Records' do
    let(:query_attributes) { { conversation_id: 1, page: 1 } }

    describe '#query_for' do
      it 'builds a query' do
        described_class.send(:query_for, *query_attributes.values).should ==
          "select * from message_groups(#{query_attributes[:conversation_id]}, #{query_attributes[:page]})"
      end
    end
  end

  context 'With Persisted Records' do
    describe '#for' do
      let(:conversation) { FactoryGirl.create(:conversation) }
      let(:users) { User.where(id: conversation.users) }
      let!(:groups) do
        2.times { conversation.append Message.new(user_id: users.first.id, interlocutor_id: users.last.id, body: 'message from user.first') }
        3.times { conversation.append Message.new(user_id: users.last.id, interlocutor_id: users.first.id, body: 'message from user.last') }
        [ Message.first(2), Message.last(3) ]
      end

      it 'returns message groups for a given conversation' do
        message_groups = MessageGroup.for(conversation.id)

        message_groups.first.group.should == groups.first
        message_groups.last.group.should  == groups.last

        message_groups.first.user.should == users.first
        message_groups.last.user.should == users.last
      end
    end
  end

end
