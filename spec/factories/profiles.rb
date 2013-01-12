# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    association :user

    preferences ''
  end

  factory :standalone_profile, class: Profile do
    preferences ''
  end
end
