require 'spec_helper'
require 'capybara/rspec'

describe 'Users Authentication' do
  describe 'Registrations' do
    let(:user) { FactoryGirl.build(:user) }

    before do
      visit new_user_registration_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      fill_in 'user_name', with: user.name

      choose 'user_male_true'
    end

    it 'succesfully passes registration' do
      click_button I18n.t('devise.registrations.new.header')

      page.should have_content( I18n.t('devise.registrations.signed_up') )
    end
  end

  describe 'Sessions' do
    let(:user) { FactoryGirl.create(:user) }

    it 'succesfully signs in' do
      sign_in user
      page.should have_content( I18n.t('devise.sessions.signed_in') )
    end
  end

  describe 'Passwords' do
    let(:user) { FactoryGirl.create(:user) }

    it 'succesfully recovers password' do
      visit new_user_password_path
      fill_in 'user_email', with: user.email
      click_button I18n.t('devise.passwords.new.submit')

      mail = ActionMailer::Base.deliveries.last
      mail.subject.should == I18n.t('devise.mailer.reset_password_instructions.subject')
      password_recovery_url = $1 if mail.body.to_s =~ /href="(.*)"/

      visit password_recovery_url
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      click_button I18n.t('devise.passwords.edit.submit')

      page.should have_content( I18n.t('devise.passwords.updated') )
    end
  end
end
