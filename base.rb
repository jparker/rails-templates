# $ rails <application name> -m http://github.com/jparker/rails-templates/...

run "echo TODO > README"

gem 'rspec', :lib => false, :env => 'test'
gem 'rspec-rails', :lib => false, :env => 'test'
gem 'cucumber', :env => 'test'
gem 'cucumber-rails', :env => 'test'
gem 'machinist', :env => 'test'
gem 'shoulda', :env => 'test'
gem 'mocha', :env => 'test'
gem 'webrat', :env => 'test'
gem 'pickle', :env => 'test'
gem 'faker', :env => 'test'

generate 'rspec'
generate 'cucumber'
generate 'pickle'

contents = File.read('spec/spec_helper.rb')
contents.sub!(/^(Spec::Runner\.configure)/, "require 'blueprints'\nrequire 'authlogic/test_case'\n\n\\1")
contents.sub!(/# (config\.mock_with :mocha)/, "\\1\n")
contents.sub!(/^end/, "\n  config.before(:all) { Sham.reset(:before_all) }\n  config.before(:each) { Sham.reset(:before_each) }\nend")
file 'spec/spec_helper.rb', contents

file 'spec/blueprints.rb', <<-END
require 'machinist/active_record'
require 'sham'
require 'faker'
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'blueprints', '**', '*.rb'))].each {|f| require f}
END
run 'mkdir -p spec/blueprints'
run 'touch spec/blueprints/.gitignore'

if File.exists?('features/support/env.rb')
  contents = File.read('features/support/env.rb')
else
  contents = ''
end
contents << <<-END
require "\#{Rails.root}/spec/blueprints"
Before { Sham.reset }
END
file 'features/support/env.rb', contents

# gem 'newrelic_rpm'
# puts <<-END
# 
#   ******************
#   ***
#   *** Install config from http://rpm.newrelic.com in config/newrelic.yml
#   ***
#   ******************
# 
# END

hoptoad_api_key = ask("What is your Hoptoad API key (leave blank to skip)?")
if hoptoad_api_key.present?
  gem 'hoptoad_notifier'
  generate 'hoptoad', :api_key => hoptoad_api_key
end

gem 'will_paginate'
gem 'formtastic'
gem 'haml'
run 'haml --rails .'
gem 'authlogic'

rake 'gems:unpack'
rake 'gems:unpack', :env => 'test'

initializer 'sass.rb', <<-END
if Rails.env.development?
  Sass::Plugin.options[:always_update] = true
  Sass::Plugin.options[:line_comments] = true
  Sass::Plugin.options[:style] = :expanded
else
  Sass::Plugin.options[:style] = :compressed
end
END

run 'mkdir -p spec/support/shoulda_macros'
run 'cp vendor/gems/authlogic-*/shoulda_macros/authlogic.rb spec/support/shoulda_macros'

plugin 'validation_reflection', :git => 'git://github.com/redinger/validation_reflection.git'
plugin 'urgetopunt_helpers', :git => 'git://github.com/jparker/urgetopunt_helpers.git'

generate 'formtastic'

file 'app/views/layouts/application.html.haml', <<-END
!!! XML
!!! Strict
%html{html_attrs}
  %head
    %title= yield(:title) || "Untitled"
    %meta{"http-equiv" => "Content-Type", :content => "text/html;charset=utf8"}
    = stylesheet_link_tag 'formtastic', 'formtastic_changes', 'application'
  %body
    .container
      #head
        %h1= yield(:title)
      #body
        - flash.each do |name, msg|
          = content_tag :div, msg, :id => 'flash', :class => name
        = yield
      #foot
END

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
contents = File.read('config/environment.rb')
contents.sub!(/# (config\.load_paths \+=) .*/, "\\1 %W( #{extra_load_paths} )")
file 'config/environment.rb', contents

run 'curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js'

# git :init
# git :add => '.'
# git :commit => '-m "Initial import"'
