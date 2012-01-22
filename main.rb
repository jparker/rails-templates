require File.join(File.dirname(__FILE__), 'helpers.rb')
apply File.join(File.dirname(__FILE__), 'gems.rb')

gsub_file 'config/database.yml', /username: #{app_name}$/, "username: #{database_username}"
rake 'db:create'

generate 'rspec:install'
append_file '.rspec', "--order random\n"
append_file 'Rakefile', <<RUBY

# On Rails 3.1 the default task is "test" even after running rspec:install. Removing
# the default task and defining it again (depending on "spec") fixes the problem.
# http://blog.elizabrock.com/post/7213861688/rails-3-1-rake-aborted-dont-know-how-to-build-task
task(:default).clear
task default: :spec
RUBY

# Rather than run spork --bootstrap, just provide a skeletal spec_helper
remove_file 'spec/spec_helper.rb'
file 'spec/spec_helper.rb', cat('spec/spec_helper.rb')

run 'bundle exec guard init spork'
run 'bundle exec guard init rspec'
gsub_file 'Guardfile', /guard 'rspec'.*/, "guard 'rspec', version: 2, cli: '--drb', all_on_start: false, all_after_pass: false do\n"
inject_into_file 'Guardfile', "require 'active_support/inflector'\n\n", before: "guard 'spork',"
inject_into_file 'Guardfile', <<RUBY, after: /guard 'spork', .*do\n/
  watch('config/routes.rb')
  watch(%r{spec/support/}) { :rspec }
RUBY
inject_into_file 'Guardfile', <<RUBY, before: 'end'
  watch(%r{^spec/factories/(.+)\.rb$}) { |m| ["spec/models/\#{m[1].singularize}_spec.rb", "spec/controllers/\#{m[1]}_controller_spec.rb", "spec/requests/\#{m[1]}_spec.rb"] }
RUBY
gsub_file 'Guardfile', 'acceptance', 'requests'

apply File.join(File.dirname(__FILE__), 'urgetopunt.rb')

inject_into_file 'config/application.rb',
  "    config.active_record.schema_format = :sql\n\n",
  after: "class Application < Rails::Application\n"
gsub_file 'config/application.rb', /# config\.autoload_paths \+= .*/, 'config.autoload_paths += %W(#{config.root}/lib)'
inject_into_file 'config/application.rb', "  Bundler.require(:darwin) if RUBY_PLATFORM.match(/darwin/i)\n", after: "if defined?(Bundler)\n"

gsub_file 'config/environments/test.rb', /# (config.active_record.schema_format = :sql)/, '\1'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', cat('app/views/layouts/application.html.haml')

apply File.join(File.dirname(__FILE__), 'sorcery.rb') if use_sorcery?

remove_file 'app/assets/stylesheets/application.css'
file "app/assets/stylesheets/application.css.scss", cat('app/assets/stylesheets/application.css.scss')

inject_into_file 'app/assets/javascripts/application.js', "//= require bootstrap-alerts\n", before: '//= require_tree .'

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

inject_into_file 'config/environments/production.rb', <<-RUBY, after: "::Application.configure do\n"
  # TODO: update sender/recipient addresses as needed
  config.middleware.use ExceptionNotifier, sender_address: 'noreply@urgetopunt.com', exception_recipients: 'jparker@urgetopunt.com'
RUBY

append_file '.gitignore', <<GIT
*.swp
*~
#*#
.DS_Store
config/database.yml
webrat.log
GIT

in_root do
  FileUtils.cp 'config/database.yml', 'config/database.example.yml'
end

remove_file 'README'
create_file 'README', "Describe this application.\n"

file '.autotest', "require 'autotest/bundler'\n"

git :init
git add: '.'
git commit: '-m initial commit'
