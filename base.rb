# $ rails <application name> -m http://github.com/jparker/rails-templates/...
#
# load_template 'http://github.com/jparker/rails-templates/...'
# generate :generator_name, args

run "echo TODO > README"

if yes?('RSpec?')
  plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
end

gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'thoughtbot-quietbacktrace', :lib => 'quietbacktrace', :source => 'http://gems.github.com'
gem 'rr'

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
run 'cp config/database.yml config/example_database.yml'

git :add => '.', :commit => '-m "Initial import"'
