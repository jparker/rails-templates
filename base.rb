# $ rails <application name> -m http://github.com/jparker/rails-templates/...

run "echo TODO > README"

gem 'faker'
gem 'machinist'
file 'spec/blueprints.rb', <<-END
require 'machinist/active_record'
require 'sham'
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'blueprints', '**', '*.rb'))].each {|f| require f}
END
run 'mkdir -p spec/blueprints'
run 'touch spec/blueprints/.gitignore'
gem 'rr'
gem 'shoulda'
gem 'webrat'
gem 'cucumber'

generate 'rspec'
generate 'cucumber'

spec_helper_contents = File.read('spec/spec_helper.rb')
spec_helper_contents.sub!(/^(Spec::Runner\.configure)/, "require 'blueprints'\n\n\\1")
spec_helper_contents.sub!(/# (config\.mock_with :rr)/, "\\1\n")
file 'spec/spec_helper.rb', spec_helper_contents

gem 'newrelic_rpm'
puts <<-END

  ******************
  ***
  *** Install config from http://rpm.newrelic.com in config/newrelic.yml
  ***
  ******************

END
hoptoad_api_key = ask("What is your Hoptoad API key (leave blank to skip)?")
if hoptoad_api_key.present?
  plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
  initializer 'hoptoad.rb', <<-END
HoptoadNotifier.configure do |config|
  config.api_key = '#{hoptoad_api_key}'
end
  END
end

gem 'will_paginate'
gem 'formtastic'
gem 'haml'
run 'haml --rails .'
gem 'authlogic'

plugin 'validation_reflection', :git => 'git://github.com/redinger/validation_reflection.git'
plugin 'urgetopunt_helpers', :git => 'git://github.com/jparker/urgetopunt_helpers.git'

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

run 'mkdir -p app/mailers app/observers spec/mailers spec/observers'

extra_load_paths = %w[mailers observers].map { |path| "\#{RAILS_ROOT}/app/#{path}" }.join(' ')
environment_contents = File.read('config/environment.rb')
environment_contents.sub!(/# (config\.load_paths \+=) .*/, "\\1 %W( #{extra_load_paths} )")
file 'config/environment.rb', environment_contents

run 'curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js'

git :init
git :add => '.'
git :commit => '-m "Initial import"'
