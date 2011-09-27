require File.join(File.dirname(__FILE__), 'helpers.rb')
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

inject_into_file 'config/application.rb',
  "    config.active_record.schema_format = :sql\n\n",
  after: "class Application < Rails::Application\n"
gsub_file 'config/application.rb', /# config\.autoload_paths \+= .*/, 'config.autoload_paths += %W(#{config.root}/lib)'

gsub_file 'config/environments/test.rb', /# (config.active_record.schema_format = :sql)/, '\1'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', cat('app/views/layouts/application.html.haml')

apply File.join(File.dirname(__FILE__), 'sorcery.rb') if use_sorcery?

generate 'formtastic:install'
inject_into_file 'app/assets/stylesheets/application.css', " *= require formtastic\n", after: "require_self\n"
generate 'responders:install'

inject_into_file 'config/locales/responders.en.yml',
  "        alert: '%{resource_name} could not be created (see errors below).'\n",
  after: "successfully created.'\n"
inject_into_file 'config/locales/responders.en.yml',
  "        alert: '%{resource_name} could not be updated (see errors below).'\n",
  after: "successfully updated.'\n"
gsub_file 'config/locales/responders.en.yml', 'destroyed', 'removed'

initializer 'rack_escape_utils.rb', cat('config/initializers/rack_escape_utils.rb')

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
