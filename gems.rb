gem 'rspec-rails', version: '~> 2.7.0', group: [:test, :development]
gem 'factory_girl_rails', group: :test
gem 'faker', group: [:test, :development]
gem 'shoulda-matchers', group: :test
gem 'mocha', group: :test
gem 'capybara', group: :test
gem 'launchy', group: :test

gem 'spork', version: '~>0.9.0.rc9', group: :test
gem 'guard-rspec', group: :test
gem 'guard-spork', group: :test

gem 'growl', group: :darwin
gem 'rb-fsevent', group: :darwin, require: false

gem 'kaminari'
gem 'formtastic'
gem 'decent_exposure'
gem 'responders'
gem 'haml'
gem 'validates_existence'
gem 'escape_utils'
gem 'exception_notification'

gem 'rails3-generators', group: :development
gem 'haml-rails', group: :development

gem 'sorcery' if use_sorcery?

run 'bundle install'
