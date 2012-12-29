require 'spec_helper'

describe Message do

  it { should belong_to(:receiver) }
  it { should belong_to(:author) }
  it { should belong_to(:conversation) }

  it { should ensure_length_of(:body).is_at_least(1).is_at_most(5000) }

  describe 'Methods' do
    let(:message) { FactoryGirl.create(:standalone_message) }

    describe '#read!' do
      before { message.should_not be_read }

      it 'marks message as read' do
        message.read!
        message.should be_read
      end
    end
  end

end
