# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_comment do
    association :user
    association :profile

    body 'Profile Comment'
  end

  factory :standalone_profile_comment, class: ProfileComment do
    body 'Profile Comment'
  end
end
