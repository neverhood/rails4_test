class SubscriptionsController < ApplicationController

  respond_to :js, :json

  before_filter :authenticate_user!
  before_filter :find_user!, only: [ :create, :destroy ]

  def index
    @users = section.direct?? current_user.subscribed_users : current_user.subscribers
  end

  def create
    render json: { notification: I18n.t('flash.subscriptions.create') },
           status: ( current_user.subscribe_to(@user) ? 200 : 422 ), text: nil
  end

  def destroy
    render json: { notification: I18n.t('flash.subscriptions.destroy') },
           status: ( current_user.unsubscribe(@user) ? 200 : 422 ), text: nil
  end

  private

  def find_user!
    @user = User.where(id: params[:user_id]).first

    render_not_found! if @user.nil?
  end

  def section
    ( (params[:section].present? and params[:section] == 'inverse') ? 'inverse' : 'direct' ).inquiry
  end

end
