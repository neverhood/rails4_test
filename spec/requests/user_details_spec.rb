require 'spec_helper'

describe 'UserDetails' do

  let(:user) { FactoryGirl.create(:user) }
  let(:new_user_attributes) { { name: 'new-user-name', login: 'new-user-login' } }
  let(:avatar) { "#{Rails.root}/app/assets/images/fallback/medium_male_default.png" }

  before { sign_in user }

  it 'updates user details' do
    visit edit_user_path

    fill_in 'user_name', with: new_user_attributes[:name]
    fill_in 'user_login', with: new_user_attributes[:login]
    attach_file 'user_avatar', avatar

    within 'form#edit-user-details' do
      click_button I18n.t('common.submit')
    end

    user.reload

    user.name.should == new_user_attributes[:name]
    user.login.should == new_user_attributes[:login]
    user.avatar.should be_present
  end

end
