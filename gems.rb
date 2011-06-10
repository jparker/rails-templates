gem 'rspec-rails', :version => '~> 2.6.0', :group => [:test, :development]
gem 'factory_girl_rails', :version => '~> 1.0.1', :group => [:test, :development]
gem 'faker', :group => [:test, :development]
gem 'shoulda', :version => '~> 2.11.3', :group => :test
gem 'mocha', :version => '~> 0.9.11', :group => :test
# TODO: switch to version after capybara 1.0 is released
gem 'capybara', :group => :test, :git => 'https://github.com/jnicklas/capybara'
gem 'launchy', :version => '~> 0.3.7', :group => :test

gem 'kaminari', :version => '~> 0.12.3'
gem 'formtastic', :version => '~> 1.2.3'
gem 'inherited_resources', :version => '~> 1.2.1'
gem 'haml', :version => '~> 3.1.1'
gem 'sass', :version => '~> 3.1.1'
gem 'authlogic', :version => '~> 3.0.2' if @use_authlogic
gem 'cancan', :version => '~> 1.6.3'
gem 'hoptoad_notifier', :version => '~> 2.4.9'
gem 'escape_utils', :version => '~> 0.2.3'
gem 'newrelic_rpm', :version => '~> 2.14.1'

gem 'rails3-generators', :group => :development
gem 'haml-rails', :group => :development
gem 'jquery-rails', :version => '~> 1.0', :group => :development

gem 'rack-ssl', :version => '~>1.3.2', :group => :production if @require_ssl

run 'bundle install'
