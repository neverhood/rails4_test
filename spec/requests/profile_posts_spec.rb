require 'spec_helper'

describe 'ProfilePost' do
  let(:user) { FactoryGirl.create(:user) }
  let(:profile_comment) { FactoryGirl.build(:profile_comment, user: user, profile: user.profile) }

  before do
    sign_in user
    visit user_path(user)
  end

  it 'posts new entity' do
    within 'form#new-profile-post' do
      fill_in 'profile_post_body', with: profile_comment.body

      find('#profile_id').set user.id rescue nil
      click_button I18n.t('common.submit')
    end

    page.should have_content(profile_comment.body)
  end
end
