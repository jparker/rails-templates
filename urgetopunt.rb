# TODO: move to urgetopunt_rails_helper gem

initializer 'urgetopunt.rb', template('config/initializers/urgetopunt.rb')
lib 'urgetopunt/migration_helpers.rb', template('lib/urgetopunt/migration_helpers.rb')
remove_file 'app/helpers/application_helper.rb'
file 'app/helpers/application_helper.rb', template('app/helpers/application_helper.rb')
