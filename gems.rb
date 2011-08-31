gem 'rspec-rails', :version => '~> 2.6.0', :group => [:test, :development]
gem 'factory_girl_rails', :version => '~> 1.1.0', :group => :test
gem 'faker', :group => [:test, :development]
gem 'shoulda', :version => '~> 2.11.3', :group => :test
gem 'mocha', :version => '~> 0.9.11', :group => :test
gem 'capybara', :group => :test, :version => '~> 1.0.0'
gem 'launchy', :version => '~> 0.3.7', :group => :test

gem 'guard-rspec', group: :test
gem 'growl_notify', group: :test
append_to_file 'Gemfile', "gem 'rb-fsevent', require: false, group: :test if RUBY_PLATFORM =~ /darwin/i\n"

gem 'kaminari', :version => '~> 0.12.3'
gem 'formtastic', :version => '~> 1.2.3'
gem 'inherited_resources', :version => '~> 1.2.1'
gem 'responders', :version => '~> 0.6.4'
gem 'haml', :version => '~> 3.1.1'
gem 'validates_existence', :version => '~> 0.7.0'
gem 'authlogic', :version => '~> 3.0.2' if use_authlogic?
gem 'cancan', :version => '~> 1.6.3'
gem 'airbrake', :version => '~> 3.0'
gem 'escape_utils', :version => '~> 0.2.3'
todo 'add newrelic_rpm to Gemfile', 'newrlic_rpm'

gem 'rails3-generators', :group => :development
gem 'haml-rails', :group => :development

gem 'rack-ssl', :version => '~>1.3.2', :group => :production if require_ssl?

run 'bundle install'
