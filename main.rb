def todo(component, message)
  say "\033[36m" + 'todo'.rjust(10) + "\033[0m    check TODO file when configuring #{component}"
  create_file 'TODO', '' unless File.exist?('TODO')
  append_file 'TODO', "---\n#{message}\n"
end

@require_ssl = yes?('Will this application require SSL in production?')
@use_authlogic = yes?('Will this application use Authlogic for authentication?')
@hoptoad_api_key = ask("What is this app's Hoptoad API key (leave blank to skip)?")

apply File.join(File.dirname(__FILE__), 'gems.rb')

generate 'rspec:install'
gsub_file 'spec/spec_helper.rb', 'config.mock_with :rspec', '# config.mock_with :rspec'
gsub_file 'spec/spec_helper.rb', '# config.mock_with :mocha', 'config.mock_with :mocha'
inject_into_file 'spec/spec_helper.rb', "require 'capybara/rspec'\n", :after => "require 'rspec/rails'\n"

apply File.join(File.dirname(__FILE__), 'defaults.rb')
apply File.join(File.dirname(__FILE__), 'urgetopunt.rb')
apply File.join(File.dirname(__FILE__), 'authlogic.rb') if @use_authlogic

todo 'cancan', '$ rails g cancan:ability'

generate 'jquery:install'
gsub_file 'config/application.rb',
          'config.action_view.javascript_expansions[:defaults] = %w()',
          'config.action_view.javascript_expansions[:defaults] = %w(jquery.min jquery_ujs)'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<HAML
!!! XML
!!! 5
%head
  %title= yield :title
  = stylesheet_link_tag :all
  = csrf_meta_tag
%body
  #head
    %h1= yield :title

  #main
    #flash
      - flash.each do |level, message|
        %p{:class => level}= message

    = yield

  #foot

  = javascript_include_tag :defaults
HAML

generate 'formtastic:install'

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

if @require_ssl
  prepend_file 'config/environments/production.rb', "require 'rack/ssl'\n\n"
  inject_into_file 'config/environments/production.rb',
    "  config.middleware.insert_before ActionDispatch::Cookies, Rack::SSL\n",
    :after => "::Application.configure do\n"
end

if @hoptoad_api_key.present?
  generate 'hoptoad', '--api-key', @hoptoad_api_key
  inject_into_file 'app/views/layouts/application.html.haml', "= hoptoad_javascript_notifier\n  ", :before => "= csrf_meta_tag"
else
  todo 'hoptoad', "$ rails g hoptoad --api-key HOPTOAD_API_KEY"
end

append_file '.gitignore', <<GIT
*.swp
*~
#*#
.DS_Store
webrat.log
GIT

file '.autotest', "require 'autotest/bundler'\n"
