apply File.join(File.dirname(__FILE__), 'pre.rb')

gem 'dm-rails', '~> 1.0.4'
gem 'dm-postgres-adapter', '~> 1.0.2'

%w(migrations types validations constraints transactions aggregates timestamps observer).each do |component|
  gem "dm-#{component}", '~> 1.0.2'
end
gem 'dm-devise', '~> 1.1.4'

# TODO: gem 'rails_metrics'

gsub_file 'config/application.rb', "require 'rails/all'" do
  <<-RUBY
require 'action_controller/railtie'
require 'dm-rails/railtie'
require 'action_mailer/railtie'
# require 'active_resource/railtie'
# require 'rails/test_unit/railtie'
  RUBY
end

db_name = app_path.split('/').last
remove_file 'config/database.yml'
create_file 'config/database.yml' do
  <<-YAML
defaults: &defaults
  adapter: postgres
  username: #{db_name}

development:
  database: #{db_name}_development
  <<: *defaults

test:
  database: #{db_name}_test
  <<: *defaults

production:
  database: #{db_name}_production
  <<: *defaults
  YAML
end

inject_into_file  'app/controllers/application_controller.rb',
                  "require 'dm-rails/middleware/identity_map'\n",
                  :before => 'class ApplicationController'
inject_into_class 'app/controllers/application_controller.rb',
                  'ApplicationController',
                  "  use Rails::DataMapper::Middleware::IdentityMap\n"

apply File.join(File.dirname(__FILE__), 'post.rb')
