# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    read false
    body 'Message text'

    association :author, :factory => :user
    association :receiver, :factory => :user

    after(:build) do |message|
      message.conversation ||= FactoryGirl.create(:conversation, users: [ message.author.id, message.receiver.id ])
    end

    after(:build) do |message|
      unless message.receiver.present? and message.author.present?
        message.author   ||= message.conversation.users && message.conversation.users.first
        message.receiver ||= message.conversation.users && message.conversation.users.last
      end
    end
  end

  factory :standalone_message, class: Message do
    read false
    body 'Message text'
  end
end
