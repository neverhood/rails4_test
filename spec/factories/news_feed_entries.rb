# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :news_feed_entry do
    entry_id 1
    entry_type 1
    user_id 1
  end
end
