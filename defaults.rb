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

use_ssl = ask('Will this application require SSL?')
if use_ssl.present? && use_ssl =~ /\Ay(es)?/i
  gem 'rack-ssl', :version => '~> 1.2.0', :group => :production
  prepend_file 'config/environments/production.rb', "require 'rack/ssl'\n\n"
  inject_into_file 'config/environments/production.rb', "\n  config.middleware.insert_before ActionDispatch::Cookies, Rack::SSL\n", :after => '::Application.configure do'
end

append_file '.gitignore', <<GIT
*.swp
*~
#*#
.DS_Store
GIT

file '.autotest', "require 'autotest/bundler'\n"
