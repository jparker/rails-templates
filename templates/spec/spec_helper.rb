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

  RSpec.configure do |config|
    config.include Factory::Syntax::Methods
    config.mock_with :mocha
    config.use_transactional_fixtures = true
  end
end

Spork.each_run do
  FactoryGirl.reload
  # FIXME: kludge to fix false runtime reports when running rspec + spork (remove with rspec 2.8)
  $rspec_start_time = Time.now
end
