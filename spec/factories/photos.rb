# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    association :album

    after(:build) do |photo|
      photo.user_id = photo.album.user_id
    end
  end
end
