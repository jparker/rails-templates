# usage: rails new <app_name> -m base.rb [options]

class Rails::Generators::AppGenerator
  def todo(message)
    create_file 'TODO', '' unless File.exist?('TODO')
    puts message
    append_file 'TODO', "---\n#{message}\n"
  end
end

gem 'rspec-rails',    :group => [:test, :development], :version => '~> 2.4'
gem 'rspec',          :group => :test, :version => '~> 2.4'
gem 'cucumber-rails', :group => :test
gem 'cucumber',       :group => :test
gem 'shoulda',        :group => :test
gem 'faker',          :group => [:test, :development]

# Capybara 0.4 bugging out when following links (undefined method node...)
gem 'capybara', :version => '~> 0.3.9', :group => :test
# gem 'webrat', :version => '0.7.2.beta.1', :group => :test

gem 'will_paginate',       :version => '>= 3.0.pre2'
gem 'formtastic',          :version => '~> 1.2.3'
gem 'inherited_resources', :version => '~> 1.1.2'
gem 'haml',                :version => '~> 3.0.25'
gem 'devise',              :version => '~> 1.1.5'
gem 'hoptoad_notifier',    :version => '~> 2.4.2'

gem 'rails3-generators', :group => :development
gem 'haml-rails',        :group => :development
gem 'jquery-rails',      :group => :development

generate 'rspec:install'
generate 'cucumber:install', '--capybara'
generate 'jquery:install'
generate 'formtastic:install'
generate 'devise:install'

# gem 'machinist', :version => '>= 2.0.0.beta2', :group => :test
# generate 'machinist:install'
gem 'factory_girl_rails', :group => :test

hoptoad_api_key = ask('What is the Hoptoad API key for this project (leave blank to skip)?')
if hoptoad_api_key.present?
  generate 'hoptoad', '--api-key', hoptoad_api_key
  inject_into_file 'config/initializers/hoptoad.rb', "  config.js_notifier = true\n", :before => 'end'
else
  todo "Skipping hoptoad configuration. To install hoptoad:\n$ rails g hoptoad --api-key HOPTOAD_API_KEY"
end

gsub_file 'spec/spec_helper.rb', 'config.mock_with :rspec', '# config.mock_with :rspec'
# gem 'rr', :group => :test
# gsub_file 'spec/spec_helper.rb', '# config.mock_with :rr', 'config.mock_with :rr'
gem 'mocha', :group => :test
gsub_file 'spec/spec_helper.rb', '# config.mock_with :mocha', 'config.mock_with :mocha'

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<END
!!! XML
!!! 5
%head
  %title= yield :title
  = stylesheet_link_tag :all
  = csrf_meta_tag
%body
  %h1= yield :title

  #flash
    %p.notice= flash[:notice]
    %p.error= flash[:error]

  = yield

  = javascript_include_tag :defaults
END

# TODO: move to urgetopunt_rails_helper gem
initializer 'urgetopunt.rb', <<END
require 'urgetopunt/migration_helpers'
END
lib 'urgetopunt/migration_helpers.rb', <<END
module Urgetopunt
  module MigrationHelper
    # add_foreign_key_constraint :items, :seller_id             # items.seller_id => sellers.id
    # add_foregin_key_constraint :messages, :sender_id, :people # messages.sender_id => people.id
    def add_foreign_key_constraint(table, column, reference_table = nil)
      reference_table ||= column.to_s.sub(/_id$/, '').tableize
      execute <<-END.squish
        ALTER TABLE      \#{connection.quote_table_name table}
        ADD FOREIGN KEY (\#{connection.quote_column_name column})
        REFERENCES       \#{connection.quote_table_name reference_table}
      END
      add_index table, column
    end
  end
end
ActiveRecord::Migration.extend Urgetopunt::MigrationHelper
END

inject_into_file 'app/helpers/application_helper.rb', <<END, :after => "module ApplicationHelper\n"
  def title(text)
    content_for :title do
      text
    end
  end

  def google_analytics(app_id)
    if Rails.env.production?
      javascript_tag <<-END
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', \#{app_id}]);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script');
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          ga.setAttribute('async', 'true');
          document.documentElement.firstChild.appendChild(ga);
        })();
      END
    end
  end
END

gem 'fuubar', :group => :test
append_file '.rspec', "--format Fuubar\n"

# TODO:
# gem 'newrelic_rpm'
