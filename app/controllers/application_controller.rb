require 'application_responder'

class ApplicationController < ActionController::Base
  clear_helpers

  self.responder = ApplicationResponder
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def find_user!
    @user = User.where( User.arel_table[:id].eq(params[:user_id]).or(User.arel_table[:login].eq(params[:user_id])) ).first
    render_not_found! if @user.nil?
  end

  def render_not_found!
    raise ActionController::RoutingError.new( I18n.t('common.not_found') )
  end
end
