if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/matchers/integrations/rspec'
  require 'capybara/rspec'
  require 'capybara/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Capybara.javascript_driver = :webkit

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.mock_with :mocha
    config.use_transactional_fixtures = true

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
  end
end

Spork.each_run do
  FactoryGirl.reload
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
end
