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
    klass = case level
            when :notice then 'alert-success'
            when :alert  then 'alert-error'
            when /.+/    then "alert-#{level}"
            else              nil
            end
    content_tag :div, class: ['alert', klass].compact, data: { dismiss: 'alert' } do
      link_to('X', '#', class: 'close') << content_tag(:p, message)
    end
  end

  def flag(text, level = nil)
    content_tag :span, text, class: ['label', "label-#{level}"].compact
  end

  def menu(resource, options = {})
    actions  = [:index, :new, :show, :edit, :destroy]
    actions &= Array.wrap(options[:only]) if options[:only]
    actions -= Array.wrap(options[:except]) if options[:except]
    extras   = Array.wrap(options[:extras])

    items = actions.inject('') do |content, action|
      content << content_tag(:li, send("link_to_#{action}", resource))
    end
    items = extras.inject(items) do |content, item|
      content << content_tag(:li, item)
    end

    content_tag :ul, items.html_safe, class: 'menu'
  end

  def link_to_index(resource, options = {})
    text = options.delete(:text) || 'All'
    path = options.delete(:path) || polymorphic_path(resource.is_a?(Class) ? resource : resource.class)
    options.reverse_merge!(title: 'All')
    link_to text, path, options
  end

  def link_to_show(resource, options = {})
    text = options.delete(:text) || 'View'
    path = options.delete(:path) || polymorphic_path(resource)
    options.reverse_merge!(title: 'View')
    link_to text, path, options
  end

  def link_to_new(resource, options = {})
    text = options.delete(:text) || 'New'
    path = options.delete(:path) || new_polymorphic_path(resource)
    options.reverse_merge!(title: 'New')
    link_to text, path, options
  end

  def link_to_edit(resource, options = {})
    text = options.delete(:text) || 'Edit'
    path = options.delete(:path) || edit_polymorphic_path(resource)
    options.reverse_merge!(title: 'Edit')
    link_to text, path, options
  end

  def link_to_destroy(resource, options = {})
    text = options.delete(:text) || 'Delete'
    path = options.delete(:path) || polymorphic_path(resource)
    options.reverse_merge!(title: 'Delete', method: :delete, data: { confirm: 'Are you sure?' })
    link_to text, path, options
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
