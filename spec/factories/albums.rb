# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :album do
    association :user

    photos_count 0
    name 'Photo Album'
  end

  factory :standalone_album, class: Album do
    name 'Photo Album'
  end
end
