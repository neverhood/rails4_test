module ApplicationHelper

  def navbar_link(text, path, options = { data: { 'no-turbolink' => true } })
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
    "<div class='page-header'> <h3> <small> #{ text } </small> </h3> </div>"
  end

end
