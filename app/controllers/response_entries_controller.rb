class ResponseEntriesController < ApplicationController
  before_filter :authenticate_user!
  after_filter :mark_entries_as_read, only: [ :index ]

  def index
    @response_entries = current_user.response_entries.includes(:author).references(:user).page( params[:page] )

    respond_to do |format|
      format.html {}
      format.json do
        render json: { entries: render_to_string(partial: 'response_entry', collection: @response_entries), last: @response_entries.last_page? }
      end
    end
  end

  private

  def mark_entries_as_read
    @response_entries.update_all read: true
  end
end
