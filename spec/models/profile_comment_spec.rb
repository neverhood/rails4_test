require 'spec_helper'

describe ProfileComment do
  it { should ensure_length_of(:body).is_at_least(1).is_at_most(1000) }

  describe 'Callbacks' do

    describe 'Feedable' do
      context 'Profile owner' do
        let(:user) { FactoryGirl.create(:user) }
        let(:comment) { FactoryGirl.create(:profile_comment, user: user) }

        it 'creates news feed entry' do
          comment.news_feed_entry.should be_present
        end
      end

      context 'Profile visitor' do
        let(:comment) { FactoryGirl.create(:visitor_profile_comment) }

        it 'won`t create news feed entry' do
          comment.news_feed_entry.should be_nil
        end
      end
    end

  end
end
