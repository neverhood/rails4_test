require 'spec_helper'

describe 'Subscriptions' do

  let(:user) { FactoryGirl.create(:user) }
  let(:subscriber) { FactoryGirl.create(:user) }

  before do
    sign_in subscriber
  end

  context 'Subscribed' do
    before { subscriber.subscribe_to(user) }

    it 'unsubscribes user' do
      visit user_path(user)

      click_link 'unsubscribe'
      subscriber.should_not be_subscribed_to(user)
    end
  end

  context 'Not subscribed' do
    it 'subscribes to user' do
      visit user_path(user)
      click_link 'subscribe'

      subscriber.should be_subscribed_to(user)
    end
  end

end
