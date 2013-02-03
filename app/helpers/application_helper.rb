module ApplicationHelper

  def navbar_link(text, path, options = {})
    "<li class='#{ current_page?(path) ? "active" : ""}'> #{ link_to text, path, options } </li>".html_safe
  end

  def error_messages_for model
    return "" if model.errors.empty?

    messages = model.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="alert alert-error" id="error-explanation">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def news_count
    unread_news_feed_entries_count + unread_response_entries_count
  end

  def unread_news_feed_entries_count
    @unread_news_feed_entries_count ||= NewsFeedEntry.for(current_user).unread.count
  end

  def unread_response_entries_count
    @unread_response_entries_count ||= current_user.response_entries.unread.count
  end

  def page_header(text = nil, subtext = nil)
    "<div class='page-header'> <h3> #{ text ? text : t('.header') } #{ subtext ? ('<small>' + subtext + '</small>') : ''} </h3> </div>".html_safe
  end

  def no_results(text = nil)
    "<div class='no-results well'> <h3> #{ text ? text : t('.no_results') } </h3> </div>".html_safe
  end

  def subheader(text)
    "<div class='page-header'> <h3> <small> #{ text } </small> </h3> </div>".html_safe
  end

  def heads_up! text
    "<div class='heads-up'> <strong> #{ t('common.heads_up!') } </strong> #{ text } </div>".html_safe
  end

  def inline_heads_up! text
    "<span class='inline-heads-up'> <span class='label label-info'> #{ t('common.heads_up!') } </span> <strong> #{ text } </span>".html_safe
  end

  def profile_visitor?
    user_signed_in? and not profile_owner?
  end

  def user_name user
    user.name || user.login
  end

end
