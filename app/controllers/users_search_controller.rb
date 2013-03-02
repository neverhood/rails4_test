class UsersSearchController < ApplicationController
  def show
  end

  # executes search
  def create
    @users = User.where(users_search_hash_params).page(params[:page])

    if users_search_params[:city_id].present?
      @users = @users.where("details @> hstore(:key, :value)", key: 'city_id', value: users_search_params[:city_id])
    elsif users_search_params[:country_id].present?
      @users = @users.where("details @> hstore(:key, :value)", key: 'country_id', value: users_search_params[:country_id])
    end

    @users.where!(User.arel_table[:name].matches("%#{user_name}%")) if user_name.present?

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: { users: render_to_string(partial: 'user', collection: @users), total: @users.total_count } }
    end
  end

  private

  def users_search_hash_params
    users_search_params.slice(:male)
  end

  def user_name
    users_search_params[:name]
  end

  def users_search_params
    params.require(:users_search).permit(:male, :name, :country_id, :city_id)
  end
end
