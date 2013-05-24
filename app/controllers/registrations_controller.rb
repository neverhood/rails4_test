class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:male, :login, :email, :name, :password, :password_confirmation, :password_current)
  end
end
