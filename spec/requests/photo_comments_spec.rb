describe 'PhotoComments' do
  let(:user) { FactoryGirl.create(:user) }
  let(:photo) { FactoryGirl.create(:photo, user: user) }
  let(:photo_comment) { FactoryGirl.build(:standalone_photo_comment) }
  let(:author) { FactoryGirl.create(:user) }

  context 'Photo Owner' do
    before { sign_in user }

    it 'allows commenting photos' do
      visit user_photo_path(user, photo)

      fill_in 'photo_comment_body', with: photo_comment.body
      click_button I18n.t('common.submit')

      user.photo_comments.count.should == 1
      user.response_entries.count.should be_zero
    end
  end

  context 'Visitor' do
    before { sign_in author }

    it 'creates notification unless commented own photo' do
      visit user_photo_path(user, photo)

      fill_in 'photo_comment_body', with: photo_comment.body
      click_button I18n.t('common.submit')

      user.response_entries.count.should == 1
    end
  end

end
