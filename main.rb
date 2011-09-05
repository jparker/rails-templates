def todo(component, message)
  say "\033[36mTODO\033[0m check TODO file when configuring #{component}"
  create_file 'TODO', '' unless File.exist?('TODO')
  append_file 'TODO', "[ ] #{message} (#{component})\n"
end

def airbrake_api_key
  @airbrake_api_key ||= ask("What is this app's Airbrake API key (leave blank to skip)?")
end

def use_airbrake?
  airbrake_api_key.present?
end

def use_authlogic?
  return @use_authlogic if defined?(@use_authlogic)
  @use_authlogic = yes?('Will this application use Authlogic for authentication?')
end

def require_ssl?
  return @require_ssl if defined?(@require_ssl)
  @require_ssl = yes?('Will this application require SSL in production?')
end

def prepend_to_rspec_config_block(text)
  inject_into_file 'spec/spec_helper.rb', text, after: "RSpec.configure do |config|\n"
end

apply File.join(File.dirname(__FILE__), 'gems.rb')

generate 'rspec:install'
gsub_file 'spec/spec_helper.rb', /(config.mock_with :rspec)/, '# \1'
gsub_file 'spec/spec_helper.rb', /# (config.mock_with :mocha)/, '\1'
gsub_file 'spec/spec_helper.rb', /(config.fixture_path =)/, '# \1'
inject_into_file 'spec/spec_helper.rb', "require 'capybara/rspec'\nrequire 'capybara/rails'\n", after: "require 'rspec/rails'\n"
prepend_to_rspec_config_block "  config.include Factory::Syntax::Methods\n"

run 'guard init rspec'

apply File.join(File.dirname(__FILE__), 'urgetopunt.rb')
apply File.join(File.dirname(__FILE__), 'authlogic.rb') if use_authlogic?

todo 'cancan', 'run the cancan:ability generator'

inject_into_file 'config/application.rb',
  "    config.active_record.schema_format = :sql\n\n",
  after: "class Application < Rails::Application\n"

gsub_file 'config/environments/test.rb', /# (config.active_record.schema_format = :sql)/, '\1'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<HAML
!!! XML
!!! 5
%head
  %title= yield :title
  = stylesheet_link_tag 'application'
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

  = javascript_include_tag 'application'
HAML
if use_authlogic?
  inject_into_file 'app/views/layouts/application.html.haml',
                   "    = link_to 'Sign out', sign_out_path\n",
                   after: "#foot\n"
end

generate 'formtastic:install'
generate 'responders:install'

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

if require_ssl?
  gsub_file 'config/environments/production.rb', /# (config\.force_ssl = true)/, '\1'
end

append_file '.gitignore', <<GIT
*.swp
*~
#*#
.DS_Store
config/database.yml
webrat.log
GIT

file '.autotest', "require 'autotest/bundler'\n"

if use_airbrake?
  generate 'airbrake', '--api-key', airbrake_api_key
  inject_into_file 'app/views/layouts/application.html.haml', "= airbrake_javascript_notifier\n  ", :before => "= csrf_meta_tag"
else
  todo 'airbrake', 'run the airbrake generator with the --api-key options'
end
