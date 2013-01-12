describe 'NewsFeedEntries' do
  let(:user) { FactoryGirl.create(:user) }
  let(:subscriber) { FactoryGirl.create(:user) }
  let(:photo_path) { "#{Rails.root}/app/assets/images/fallback/medium_male_default.png" }
  let!(:photo) { FactoryGirl.create(:standalone_photo, image: File.open(photo_path), user: user) }

  before do
    subscriber.subscribe_to user
    sign_in subscriber
    visit user_path(subscriber)
  end

  it 'shows news feed entry on a user profile page' do
    page.should have_selector('div#news-feed div.news-feed-entry img')
  end
end
