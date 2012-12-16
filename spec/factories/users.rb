# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-email-#{n}@gmail.com" }
    password 'qwerty123'

    male true
  end
end
