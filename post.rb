generate 'rspec:install'
append_file '.rspec', "--format Fuubar\n"
gsub_file 'spec/spec_helper.rb', 'config.mock_with :rspec', '# config.mock_with :rspec'
gem 'rr', :group => :test
gsub_file 'spec/spec_helper.rb', '# config.mock_with :rr', 'config.mock_with :rr'
# gem 'mocha', :group => :test
# gsub_file 'spec/spec_helper.rb', '# config.mock_with :mocha', 'config.mock_with :mocha'

generate 'cucumber:install', '--capybara'
gsub_file 'features/support/env.rb', '# DatabaseCleaner.strategy', 'DatabaseCleaner.strategy'
file 'features/support/factory_girl_steps.rb', "require 'factory_girl/step_definitions'\n"

generate 'jquery:install'
generate 'formtastic:install'

generate 'devise:install'
inject_into_file 'spec/spec_helper.rb', "  config.include Devise::Helpers, :type => :controller\n", :after => 'RSpec.configure do |config|'
todo 'cancan', '$ rails g cancan:ability'

hoptoad_api_key = ask('What is the Hoptoad API key for this project (leave blank to skip)?')
if hoptoad_api_key.present?
  generate 'hoptoad', '--api-key', hoptoad_api_key
  inject_into_file 'config/initializers/hoptoad.rb', "  config.js_notifier = true\n", :before => 'end'
else
  todo 'hoptoad', "$ rails g hoptoad --api-key HOPTOAD_API_KEY"
end
