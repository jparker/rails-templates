rake 'sorcery:bootstrap'
generate 'sorcery_migration', 'core', 'remember_me'

file 'spec/support/authentication_macros.rb',  cat('spec/support/authentication_macros.rb')
file 'spec/factories/users.rb',                cat('spec/factories/users.rb')
file 'spec/models/user_spec.rb',               cat('spec/models/user_spec.rb')
file 'spec/routing/sessions_routing_spec.rb',  cat('spec/routing/sessions_routing_spec.rb')
file 'spec/routing/users_routing_spec.rb',     cat('spec/routing/users_routing_spec.rb')
file 'spec/requests/sessions_spec.rb',         cat('spec/requests/sessions_spec.rb')
file 'spec/requests/users_spec.rb',            cat('spec/requests/users_spec.rb')
file 'app/models/user.rb',                     cat('app/models/user.rb')
file 'app/controllers/sessions_controller.rb', cat('app/controllers/sessions_controller.rb')
file 'app/controllers/users_controller.rb',    cat('app/controllers/users_controller.rb')
file 'app/views/sessions/new.html.haml',       cat('app/views/sessions/new.html.haml')
file 'app/views/users/index.html.haml',        cat('app/views/users/index.html.haml')
file 'app/views/users/show.html.haml',         cat('app/views/users/show.html.haml')
file 'app/views/users/new.html.haml',          cat('app/views/users/new.html.haml')
file 'app/views/users/edit.html.haml',         cat('app/views/users/edit.html.haml')
file 'app/views/users/_user.html.haml',        cat('app/views/users/_user.html.haml')
file 'app/views/users/_form.html.haml',        cat('app/views/users/_form.html.haml')

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

inject_into_file 'app/views/layouts/appliation.html.haml', <<HAML, after: "#foot\n"
    - if current_user
      You are signed in as \#{current_user.username}
      |
      = link_to 'Sign out', sign_out_path
HAML
file 'app/views/layouts/sessions.html.haml', cat('app/views/layouts/sessions.html.haml')
