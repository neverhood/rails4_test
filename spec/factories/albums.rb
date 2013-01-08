# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :album do
    association :user

    name 'Photo Album'
  end

  factory :standalone_album, class: Album do
    name 'Photo Album'
  end
end
