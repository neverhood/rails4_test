class UserAvatarsController < ApplicationController
  respond_to :js, :json

  def create
    current_user.update_attributes(user_avatar_params)

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { image: { medium: current_user.avatar.url(:medium), thumb: current_user.avatar.url(:thumb) } } }
    end
  end

  def update
    current_user.update_attributes(user_avatar_params)

    render json: { image: { medium: current_user.avatar.url(:medium), thumb: current_user.avatar.url(:thumb) } }
  end

  def destroy
    current_user.update_attributes(remove_avatar: true)

    render json: { image: { medium: current_user.avatar.url(:medium), thumb: current_user.avatar.url(:thumb) } }
  end

  private

  def user_avatar_params
    params.require(:user).permit(:avatar, :crop_x, :crop_y, :crop_h, :crop_w)
  end

end
