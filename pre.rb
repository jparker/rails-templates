# usage: rails new <app_name> -m base.rb -T -J [options]
# => include -T option to skip Test::Unit files (template uses RSpec)
# => include -J option to skip Prototype files (template uses jQuery)

class Rails::Generators::AppGenerator
  def todo(component, message)
    say "\033[36m" + 'todo'.rjust(10) + "\033[0m    check TODO when configuring #{component}"
    create_file 'TODO', '' unless File.exist?('TODO')
    append_file 'TODO', "---\n#{message}\n"
  end
end

gem 'rspec-rails',    :group => [:test, :development], :version => '~> 2.4'
gem 'cucumber-rails', :group => :test
gem 'shoulda',        :group => :test
gem 'fuubar', :group => :test
gem 'faker',          :group => [:test, :development]

# Capybara 0.4 bugging out when following links (undefined method node...)
gem 'capybara', :version => '~> 0.3.9', :group => :test
# gem 'webrat', :version => '0.7.2.beta.1', :group => :test

gem 'will_paginate',       :version => '>= 3.0.pre2'
gem 'formtastic',          :version => '~> 1.2.3'
gem 'inherited_resources', :version => '~> 1.1.2'
gem 'haml',                :version => '~> 3.0.25'
gem 'devise',              :version => '~> 1.1.5'
gem 'cancan',              :version => '~> 1.5.0'
gem 'hoptoad_notifier',    :version => '~> 2.4.2'
gem 'escape_utils',        :version => '~> 0.1.9'

gem 'rails3-generators', :group => :development
gem 'haml-rails',        :group => :development
gem 'jquery-rails',      :group => :development

# gem 'machinist', :version => '>= 2.0.0.beta2', :group => :test
# generate 'machinist:install'
gem 'factory_girl_rails', :group => :test

initializer 'rack_escape_utils.rb', <<RUBY
# http://openhood.com/rack/ruby/2010/07/15/rack-test-warning/
require 'escape_utils/html/rack'
require 'escape_utils/html/haml'

module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end
RUBY

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<RUBY
!!! XML
!!! 5
%head
  %title= yield :title
  = stylesheet_link_tag :all
  = csrf_meta_tag
%body
  %h1= yield :title

  #flash
    %p.notice= flash[:notice]
    %p.error= flash[:error]

  = yield

  = javascript_include_tag :defaults
RUBY

inject_into_file 'app/helpers/application_helper.rb', <<RUBY, :after => "module ApplicationHelper\n"
  def title(text)
    content_for :title do
      text
    end
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
RUBY

# TODO: gem 'newrelic_rpm'
# TODO: run 'bundle install' (and delay actions that depend on gems)
