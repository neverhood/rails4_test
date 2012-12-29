# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    after(:build) do |conversation|
      conversation.users ||= [ FactoryGirl.create(:user).id, FactoryGirl.create(:user).id ]
    end
  end

  factory :standalone_conversation, class: Conversation do
    # silence ..
  end
end
