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

def use_sorcery?
  return @use_sorcery if defined?(@use_sorcery)
  @use_sorcery = yes?('Generate barebones authentication using Sorcery?')
end

def require_ssl?
  return @require_ssl if defined?(@require_ssl)
  @require_ssl = yes?('Will this application require SSL in production?')
end

def prepend_to_rspec_config(text)
  inject_into_file 'spec/spec_helper.rb', text, after: "RSpec.configure do |config|\n"
end
alias rspec_config prepend_to_rspec_config

def template(filename)
  path = File.expand_path(File.join(File.dirname(__FILE__), 'templates', filename))
  if filename.end_with?('.erb')
    ERB.new(File.read(path)).result
  else
    File.read(path)
  end
end

apply File.join(File.dirname(__FILE__), 'gems.rb')

generate 'rspec:install'
append_file 'Rakefile', <<RUBY

# On Rails 3.1 the default task is "test" even after running rspec:install. Removing
# the default task and defining it again (depending on "spec") fixes the problem.
# http://blog.elizabrock.com/post/7213861688/rails-3-1-rake-aborted-dont-know-how-to-build-task
task(:default).clear
task default: :spec
RUBY

gsub_file 'spec/spec_helper.rb', /(config.mock_with :rspec)/, '# \1'
gsub_file 'spec/spec_helper.rb', /# (config.mock_with :mocha)/, '\1'
gsub_file 'spec/spec_helper.rb', /(config.fixture_path =)/, '# \1'
inject_into_file 'spec/spec_helper.rb', "require 'capybara/rspec'\nrequire 'capybara/rails'\n", after: "require 'rspec/rails'\n"
rspec_config "  config.include Factory::Syntax::Methods\n"

run 'bundle exec guard init rspec'

apply File.join(File.dirname(__FILE__), 'urgetopunt.rb')
apply File.join(File.dirname(__FILE__), 'sorcery.rb') if use_sorcery?

todo 'cancan', 'run the cancan:ability generator'

inject_into_file 'config/application.rb',
  "    config.active_record.schema_format = :sql\n\n",
  after: "class Application < Rails::Application\n"

gsub_file 'config/environments/test.rb', /# (config.active_record.schema_format = :sql)/, '\1'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', template('app/views/layouts/application.html.haml')
if use_sorcery?
  inject_into_file 'app/views/layouts/application.html.haml',
                   "    = link_to 'Sign out', sign_out_path\n",
                   after: "#foot\n"
  file 'app/views/layouts/sessions.html.haml', template('app/views/layouts/sessions.html.haml')
end

generate 'formtastic:install'
generate 'responders:install'

inject_into_file 'config/locales/responders.en.yml',
  "        alert: '%{resource_name} could not be created (see errors below).'\n",
  after: "successfully created.'\n"
inject_into_file 'config/locales/responders.en.yml',
  "        alert: '%{resource_name} could not be updated (see errors below).'\n",
  after: "successfully updated.'\n"
gsub_file 'config/locales/responders.en.yml', 'destroyed', 'removed'

initializer 'rack_escape_utils.rb', template('config/initializers/rack_escape_utils.rb')

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
  inject_into_file 'app/views/layouts/application.html.haml', "= airbrake_javascript_notifier\n  ", before: "= csrf_meta_tag"
else
  todo 'airbrake', 'run the airbrake generator with the --api-key options'
end
