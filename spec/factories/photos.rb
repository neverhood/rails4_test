# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    description 'a photo'

    after(:build) do |photo|
      if photo.user_id.present? and not photo.album_id.present?
        photo.album_id = FactoryGirl.create(:album, user: photo.user).id
      end

      photo.user_id ||= photo.album.user_id
    end
  end

  factory :standalone_photo, class: Photo do
    description 'a photo'
  end
end
