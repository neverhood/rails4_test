FactoryGirl.define do
  factory :photo_comment do
    association :photo

    body 'Profile Comment'
    after(:build) { |comment| comment.user_id = comment.photo.user_id }
  end

  factory :standalone_photo_comment, class: ProfileComment do
    body 'Profile Comment'
  end
end
