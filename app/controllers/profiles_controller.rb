class ProfilesController < ApplicationController
  before_filter :find_user!, only: [ :show ]

  def show
  end

end
