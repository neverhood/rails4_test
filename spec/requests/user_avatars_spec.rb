describe 'UserAvatars' do

  let(:user) { FactoryGirl.create(:user) }
  let(:avatar) { "#{Rails.root}/app/assets/images/fallback/medium_male_default.png" }

  before do
    sign_in user
    visit user_path(user)
  end

  describe 'create' do
    it 'uploads new avatar' do
      attach_file 'user_avatar', avatar
      within 'form#new-user-avatar' do
        click_button I18n.t('common.submit')
      end

      user.reload.avatar.should be_present
    end
  end

  describe 'destroy' do
    it 'destroys avatar' do
      user.update_attributes(avatar: File.open(avatar))

      click_link 'delete-user-avatar'
      user.reload.avatar.should_not be_present
    end
  end

end
