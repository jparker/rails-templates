gem 'rspec-rails', version: '~> 2.6.0', group: [:test, :development]
gem 'factory_girl_rails', version: '~> 1.2.0', group: :test
gem 'faker', group: [:test, :development]
gem 'shoulda-matchers', version: '~> 1.0.0.beta3', group: :test
gem 'mocha', version: '~> 0.9.11', group: :test
gem 'capybara', group: :test, version: '~> 1.1.0'
gem 'launchy', group: :test

gem 'guard-rspec', group: :test
gem 'growl_notify', group: :test
gem 'rb-fsevent', group: :test, require: false

gem 'kaminari', version: '~> 0.12.3'
gem 'formtastic', version: '~> 2.0.0'
gem 'inherited_resources', version: '~> 1.2.1'
gem 'responders', version: '~> 0.6.4'
gem 'haml', version: '~> 3.1.1'
gem 'validates_existence', version: '~> 0.7.0'
gem 'sorcery' if use_sorcery?
gem 'airbrake', version: '~> 3.0'
gem 'escape_utils', version: '~> 0.2.3'

todo 'add newrelic_rpm to Gemfile when ready to configure', 'newrlic_rpm'

gem 'rails3-generators', group: :development
gem 'haml-rails', group: :development

run 'bundle install'
