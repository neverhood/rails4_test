module AuthHelper
  def sign_in user
    sign_out

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button I18n.t('auth.sign_in')
  end

  def sign_out
    visit root_path
    click_link I18n.t('auth.sign_out') if page.has_content?( I18n.t('auth.sign_out') )
  end
end
