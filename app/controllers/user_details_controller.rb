class UserDetailsController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!

  def edit
  end

  def update
    current_user.update user_details_params

    respond_with current_user
  end

  private

  def user_details_params
    params.require(:user).permit(:login, :avatar, :name, details: [ :country_id, :city_id ])
  end

end
