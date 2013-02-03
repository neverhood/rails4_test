class NewsFeedEntriesController < ApplicationController
  before_filter :authenticate_user!
  after_filter :mark_entries_as_read, only: [ :index ]

  def index
    @news_feed_entries = NewsFeedEntry.for(current_user).page( params[:page] )

    respond_to do |format|
      format.html {}
      format.json do
        render json: { entries: render_to_string(partial: 'news_feed_entry', collection: @news_feed_entries), last: @news_feed_entries.last_page? }
      end
    end
  end

  private

  def mark_entries_as_read
    @news_feed_entries.update_all read: true
  end
end
