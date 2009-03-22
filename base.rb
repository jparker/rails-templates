# $ rails <application name> -m http://github.com/jparker/rails-templates/...
#
# load_template 'http://github.com/jparker/rails-templates/...'
# generate :generator_name, args

run "echo TODO > README"

if yes?('Testing with RSpec?')
  plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
end

gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'rr'
gem 'redgreen'

gem 'haml'
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'

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
file 'test/test_helper.rb', <<-END
ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require 'test_help'
require 'redgreen' unless ENV['TM_MODE']

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
  
  include RR::Adapters::TestUnit
end
END

git :add => '.', :commit => '-m "Initial import"'
