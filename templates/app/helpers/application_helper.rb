module ApplicationHelper
  def breadcrumbs(crumbs)
    provide(:title) { crumbs.keys.join(' / ') }

    content_tag :ul, class: 'breadcrumb' do
      crumbs.map do |text, url|
        content_tag :li, url.present? ? link_to(h(text), url) : h(text)
      end.join(content_tag :span, '/', class: 'divider').html_safe
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

  def menu(resource, options = {})
    actions = [:index, :new, :show, :edit, :destroy]
    actions &= Array.wrap(options[:only]) if options[:only]
    actions -= Array.wrap(options[:except]) if options[:except]

    content_tag :li, class: 'menu' do
      actions.inject('') do |items, action|
        items << content_tag(:li, send("link_to_#{action}", resource))
      end.html_safe
    end
  end

  def link_to_index(resource, options = {})
    text = options.delete(:text) || 'List'
    options.reverse_merge!(title: 'List')
    link_to text, polymorphic_path(resource.class), options
  end

  def link_to_show(resource, options = {})
    text = options.delete(:text) || 'View'
    options.reverse_merge!(title: 'View')
    link_to text, polymorphic_path(resource), options
  end

  def link_to_new(resource, options = {})
    text = options.delete(:text) || 'New'
    options.reverse_merge!(title: 'New')
    link_to text, new_polymorphic_path(resource), options
  end

  def link_to_edit(resource, options = {})
    text = options.delete(:text) || 'Edit'
    options.reverse_merge!(title: 'Edit')
    link_to text, edit_polymorphic_path(resource), options
  end

  def link_to_destroy(resource, options = {})
    text = options.delete(:text) || 'Delete'
    options.reverse_merge!(title: 'Delete', method: :delete, confirm: 'Are you sure?')
    link_to text, polymorphic_path(resource), options
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
