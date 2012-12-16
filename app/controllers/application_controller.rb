require 'application_responder'

class ApplicationController < ActionController::Base
  clear_helpers

  self.responder = ApplicationResponder
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
