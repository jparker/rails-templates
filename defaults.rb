remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<HAML
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

append_file '.gitignore', <<GIT
*.swp
*~
#*#
.DS_Store
GIT
