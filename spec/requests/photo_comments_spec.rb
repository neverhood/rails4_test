describe 'PhotoComments' do
  let(:user) { FactoryGirl.create(:user) }
  let(:photo) { FactoryGirl.create(:photo, user: user) }
  let(:photo_comment) { FactoryGirl.build(:standalone_photo_comment) }

  before { sign_in user }

  it 'allows commenting photos' do
    visit user_photo_path(user, photo)

    fill_in 'photo_comment_body', with: photo_comment.body
    click_button I18n.t('common.submit')

    user.photo_comments.count.should == 1
  end
end
