module ApplicationHelper
  def title(*crumbs)
    provide :title do
      crumbs.map { |str| h(str) }.join(' &raquo; ').html_safe
    end
  end

  def render_flash(level, message)
    klass = level == :notice ? :success : level == :alert ? :error : level
    content_tag :div, class: ['alert-message', klass], data: {alert: 'alert'} do
      link_to('x', '#', class: 'close') << content_tag(:p, message)
    end
  end

  def flag(text, level = nil)
    content_tag :span, text, class: ['label', level].compact
  end

  def link_to_index(path, options = {})
    text = options.delete(:text) || raw('&laquo; List')
    link_to text, path, class: ['btn', 'small', 'primary'], title: 'List'
  end

  def link_to_show(path, options = {})
    text = options.delete(:text) || raw('View &raquo;')
    link_to text, path, class: ['btn', 'small', 'info'], title: 'View'
  end

  def link_to_new(path, options = {})
    text = options.delete(:text) || raw('New &raquo;')
    link_to text, path, class: ['btn', 'small', 'success'], title: 'New'
  end

  def link_to_edit(path, options = {})
    text = options.delete(:text) || raw('Edit &rqauo;')
    link_to text, path, class: ['btn', 'small'], title: 'Edit'
  end

  def link_to_destroy(path, options = {})
    text = options.delete(:text) || raw('Delete &raquo;')
    link_to text, path, class: ['btn', 'small', 'danger'], title: 'Delete', method: :delete, confirm: 'Are you sure?'
  end

  def google_analytics(app_id)
    if Rails.env.production?
      javascript_tag <<-END
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', \#{app_id}]);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script');
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          ga.setAttribute('async', 'true');
          document.documentElement.firstChild.appendChild(ga);
        })();
      END
    end
  end
end
