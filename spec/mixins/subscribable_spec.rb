require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user) }
  let(:subscriber) { FactoryGirl.create(:user) }

  describe 'Subscribable' do

    describe 'Associations' do
      it { should have_many :subscribers }
      it { should have_many :subscribed_users }
    end

    describe '#subscribe_to' do

      context 'unsubscribed' do
        it 'subscribes to user' do
          subscriber.subscribe_to user

          subscriber.subscribed_users.should include(user)
          user.subscribers.should include(subscriber)
        end
      end

      context 'already subscribed' do
        before { subscriber.subscribe_to user }

        it 'fails to subscribe' do
          subscriber.subscribe_to(user).should be_false
        end
      end

    end

    describe '#unsubscribe' do
      context 'subscribed' do
        before { subscriber.subscribe_to user }

        it 'unsubscribes user' do
          subscriber.unsubscribe user

          subscriber.subscribed_users.should_not include(user)
          user.subscribers.should_not include(subscriber)
        end
      end

      context 'unsubscribed' do
        it 'fails' do
          subscriber.unsubscribe(user).should be_false
        end
      end
    end

    describe '#subscribed_to?' do
      context 'subscribed' do
        before { subscriber.subscribe_to user }

        specify { subscriber.should be_subscribed_to(user) }
      end

      context 'not subscribed' do
        specify { subscriber.should_not be_subscribed_to(user) }
      end
    end

  end

end
