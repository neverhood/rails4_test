module Subscribable

  def subscribe_to user
    return false if subscribed_to?(user)

    subscriptions.create(subscribed_user_id: user.id)
  end

  def unsubscribe user
    return false unless subscribed_to? user

    subscriptions.where(subscribed_user_id: user.id).destroy_all
  end

  def subscribed_to? user
    subscribed_users.where(id: user.id).any?
  end

  def self.included(base)
    base.has_many :subscriptions
    base.has_many :inverse_subscriptions, class_name: 'Subscription', foreign_key: 'subscribed_user_id'
    base.has_many :subscribed_users, :through => :subscriptions
    base.has_many :subscribers, :through => :inverse_subscriptions, :source => :user
  end

end
