require 'spec_helper'

describe NewsFeedEntry do
  it { should belong_to(:entry) }
  it { should belong_to(:user ) }

  describe 'Scopes' do
    describe '#for' do
      let(:user) { FactoryGirl.create(:user) }
      let(:subscriber) { FactoryGirl.create(:user) }

      before do
        subscriber.subscribe_to user
      end

      it 'fetches a list of news feed entries for given user' do
        news_feed_entry = FactoryGirl.create(:standalone_photo, user: user).news_feed_entry

        described_class.for(subscriber).should include(news_feed_entry)
      end
    end
  end
end
