class ProfilesController < ApplicationController
  before_filter :find_user!, only: [ :show ]

  def show
    @conversation = current_user.conversation_with(@user) if current_user.has_conversation_with?(@user)
  end

end
