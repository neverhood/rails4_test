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

  def page_header(text = nil)
    "<div class='page-header'> <h3> #{ text ? text : t('.header') } </h3> </div>".html_safe
  end

  def subheader(text)
    "<div class='page-header'> <h3> <small> #{ text } </small> </h3> </div>".html_safe
  end

  def heads_up! text
    "<div class='heads-up'> <strong> #{ t('common.heads_up!') } </strong> #{ text } </div>".html_safe
  end

  def profile_owner?
    @user.present? and user_signed_in? and ( current_user.id == @user.id )
  end

  def profile_visitor?
    user_signed_in? and not profile_owner?
  end

end
