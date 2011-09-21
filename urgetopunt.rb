# TODO: move to urgetopunt_rails_helper gem

initializer 'urgetopunt.rb', cat('config/initializers/urgetopunt.rb')
lib 'urgetopunt/migration_helpers.rb', cat('lib/urgetopunt/migration_helpers.rb')
remove_file 'app/helpers/application_helper.rb'
file 'app/helpers/application_helper.rb', cat('app/helpers/application_helper.rb')
