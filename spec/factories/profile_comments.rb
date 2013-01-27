# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_comment do
    association :user

    body 'Profile Comment'
    after(:build) { |comment| comment.profile_id = comment.user.profile.id }
  end

  factory :visitor_profile_comment, class: ProfileComment do
    association :user

    body 'Profile Comment'

    after(:build) { |comment| comment.profile_id = FactoryGirl.create(:user).profile.id }
  end

  factory :standalone_profile_comment, class: ProfileComment do
    body 'Profile Comment'
  end
end
