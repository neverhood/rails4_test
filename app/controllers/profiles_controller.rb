class ProfilesController < ApplicationController
  before_filter :find_user!, only: [ :show ]

  def show
    @conversation = current_user.conversation_with(@user) if current_user.has_conversation_with?(@user)
    @news_feed_entries = NewsFeedEntry.for(current_user).page( params[:page] )

    respond_to do |format|
      format.html {}
      format.json do
        render json: { entries: render_to_string(partial: 'news_feed_entries/news_feed_entry', collection: @news_feed_entries), last: @news_feed_entries.last_page? }
      end
    end
  end

end
