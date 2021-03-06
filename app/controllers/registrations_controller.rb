class RegistrationsController < Devise::RegistrationsController
  before_filter :permissions

  private

  def permissions
    devise_permitted [ :male, :login, :details, :email, :password, :password_confirmation, :password_current ]
  end
end
