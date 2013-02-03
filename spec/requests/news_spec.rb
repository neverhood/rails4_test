require 'spec_helper'

describe 'News' do
  let(:user) { FactoryGirl.create(:user) }
  let(:subscriber) { FactoryGirl.create(:user) }

  before do
    subscriber.subscribe_to user

    FactoryGirl.create(:profile_comment, user: user, profile_id: user.profile.id)
  end

  it 'notifies subscriber with new events' do
    sign_in subscriber

    page.should_not have_content( "#{ I18n.t('news_feed_entries.index.header') } +1")
  end
end
