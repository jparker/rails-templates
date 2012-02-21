gem 'rspec-rails', version: '~> 2.8.1', group: [:test, :development]
gem 'ffaker', group: [:test, :development]
gem 'factory_girl_rails', group: :test
gem 'shoulda-matchers', group: :test
gem 'mocha', group: :test
gem 'capybara', group: :test
gem 'capybara-webkit', group: :test
gem 'launchy', group: :test
gem 'spork', group: :test
gem 'guard-rspec', group: :test
gem 'guard-spork', group: :test
gem 'simplecov', require: false, group: :test

gem 'rein'
gem 'haml'
gem 'haml-rails'
gem 'kaminari'
gem 'simple_form', '~> 2.0.0.rc'
gem 'decent_exposure'
gem 'responders'
gem 'validates_existence'
gem 'escape_utils'
gem 'exception_notification'
gem 'rails3-generators'
gem 'sorcery' if use_sorcery?

gem 'bootstrap-sass', group: :assets
gem 'jquery-ui-rails', group: :assets

gem 'growl', group: :darwin
gem 'rb-fsevent', group: :darwin, require: false

run 'bundle install'
