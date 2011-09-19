rake 'sorcery:bootstrap'
generate 'sorcery_migration', 'core', 'remember_me'

file 'spec/support/authentication_macros.rb',  template('spec/support/authentication_macros.rb')
file 'spec/factories/users.rb',                template('spec/factories/users.rb')
file 'spec/models/user_spec.rb',               template('spec/models/user_spec.rb')
file 'spec/routing/sessions_routing_spec.rb',  template('spec/routing/sessions_routing_spec.rb')
file 'spec/routing/users_routing_spec.rb',     template('spec/routing/users_routing_spec.rb')
file 'spec/requests/sessions_spec.rb',         template('spec/requests/sessions_spec.rb')
file 'spec/requests/users_spec.rb',            template('spec/requests/users_spec.rb')
file 'app/models/user.rb',                     template('app/models/user.rb')
file 'app/controllers/sessions_controller.rb', template('app/controllers/sessions_controller.rb')
file 'app/controllers/users_controller.rb',    template('app/controllers/users_controller.rb')
file 'app/views/sessions/new.html.haml',       template('app/views/sessions/new.html.haml')
file 'app/views/users/index.html.haml',        template('app/views/users/index.html.haml')
file 'app/views/users/show.html.haml',         template('app/views/users/show.html.haml')
file 'app/views/users/new.html.haml',          template('app/views/users/new.html.haml')
file 'app/views/users/edit.html.haml',         template('app/views/users/edit.html.haml')
file 'app/views/users/_user.html.haml',        template('app/views/users/_user.html.haml')
file 'app/views/users/_form.html.haml',        template('app/views/users/_form.html.haml')

route "root to: 'users#index'"
route "match '/sign_out' => 'sessions#destroy', as: :sign_out"
route "match '/sign_in' => 'sessions#new', as: :sign_in"
route "resource :session"
route "resources :users"

remove_file 'public/index.html'

rspec_config <<RUBY
  config.include AuthenticationMacros, type: :request

  # speed up password encryption during testing
  config.before(:suite) { Sorcery::CryptoProviders::BCrypt.cost = 1 }
RUBY
