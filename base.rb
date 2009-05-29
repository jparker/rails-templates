# $ rails <application name> -m http://github.com/jparker/rails-templates/...
#
# load_template 'http://github.com/jparker/rails-templates/...'
# generate :generator_name, args

run "echo TODO > README"

gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'webrat'
gem 'rr'
gem 'redgreen'

gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'

gem 'haml'
run 'haml --rails .'

gem 'newrelic_rpm'
puts "Don't forget to install your newrelic config in config/newrelic.yml!"

hoptoad_api_key = ask("What is your Hoptoad API key (leave blank to skip)?")
unless hoptoad_api_key.blank?
  plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
  initializer 'hoptoad.rb', <<-CODE
HoptoadNotifier.configure do |config|
  config.api_key = '#{hoptoad_api_key}'
end
  CODE
end

git :init

file '.gitignore', <<-END
.DS_Store
*~
.#*
.*.swp
db/*.sqlite3*
log/*.log
tmp/**/*
config/database.yml
public/stylesheets/application.css
END
run 'touch tmp/.gitignore log/.gitignore'
run 'mkdir -p public/stylesheets/sass'
run 'touch public/stylesheets/sass/.gitignore'
run 'cp config/database.yml config/example_database.yml'

# TODO: Better to edit existing version rather than overwrite?
file 'test/test_helper.rb', <<-CODE
ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require 'test_help'
require 'redgreen' unless ENV['TM_MODE']

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
  
  include RR::Adapters::TestUnit
end
CODE

git :add => '.', :commit => '-m "Initial import"'
