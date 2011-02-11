gem 'rspec-rails',          :version => '~> 2.5.0',         :group => [:test, :development]
gem 'rspec',                :version => '~> 2.5.0',         :group => :test
gem 'cucumber-rails',       :version => '~> 0.4.0.beta.1',  :group => [:test, :development]
todo 'cucumber-rails', 'switch to HEAD (https://github.com/aslakhellesoy/cucumber-rails.git)'
gem 'cucumber',             :version => '~> 0.10.0',        :group => :test
gem 'capybara',             :version => '~> 0.4.1',         :group => :test
gem 'database_cleaner',     :version => '~> 0.6.2',         :group => :test
gem 'factory_girl_rails',   :version => '~> 1.0.1',         :group => [:test, :development]
gem 'factory_girl',         :version => '~> 1.3.3',         :group => [:test, :development]
gem 'faker',                                                :group => [:test, :development]
gem 'shoulda',              :version => '~> 2.11.3',        :group => :test
gem 'mocha',                :version => '~> 0.9.11',        :group => :test
# required for view testing in rspec -- capybara won't work
gem 'webrat',               :version => '~> 0.7.3',         :group => :test
gem 'fuubar',                                               :group => :test

# http://groups.google.com/group/mail-ruby/browse_thread/thread/e93bbd05706478dd?pli=1
gem 'mail',                 :version => '~> 2.2.15'

gem 'will_paginate',        :version => '>= 3.0.pre2'
gem 'formtastic',           :version => '~> 1.2.3'
gem 'inherited_resources',  :version => '~> 1.2.1'
gem 'haml',                 :version => '~> 3.0.25'
gem 'devise',               :version => '>= 1.2.rc'
gem 'cancan',               :version => '~> 1.5.0'
gem 'hoptoad_notifier',     :version => '~> 2.4.5'
gem 'escape_utils',         :version => '~> 0.1.9'
gem 'newrelic_rpm',         :version => '~> 2.13.4'

gem 'rails3-generators',                                    :group => :development
gem 'haml-rails',                                           :group => :development
gem 'jquery-rails',                                         :group => :development
