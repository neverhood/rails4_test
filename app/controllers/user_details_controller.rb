class UserDetailsController < ApplicationController
  include Nillable

  respond_to :html

  before_filter :authenticate_user!

  nullifies user: { details: [ :city_id, :country_id ] }, only: [ :update ]

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
