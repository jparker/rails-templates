# TODO: move to urgetopunt_rails_helper gem

remove_file 'app/helpers/application_helper.rb'
file 'app/helpers/application_helper.rb', cat('app/helpers/application_helper.rb')
