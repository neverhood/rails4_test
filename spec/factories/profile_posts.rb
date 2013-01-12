# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_post do
    post_id 1
    post_type 1
    user_id 1
  end
end
