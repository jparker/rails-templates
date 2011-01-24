# TODO: move to urgetopunt_rails_helper gem

initializer 'urgetopunt.rb', <<RUBY
require 'urgetopunt/migration_helpers'
RUBY

lib 'urgetopunt/migration_helpers.rb', <<RUBY
module Urgetopunt
  module MigrationHelper
    def add_foreign_key_constraint(table, column, options = {})
      ref_table = options[:ref_table] || column.to_s.sub(/_id$/, '').tableize
      ref_column = options[:ref_column] || :id
      index = options.has_key?(:index) ? options[:index] : true

      execute <<-SQL.squish
        ALTER TABLE      \#{connection.quote_table_name table}
        ADD FOREIGN KEY (\#{connection.quote_column_name column})
        REFERENCES       \#{connection.quote_table_name ref_table}(\#{connection.quote_column_name ref_column})
      SQL
      add_index table, column if index
    end
  end
end
ActiveRecord::Migration.extend Urgetopunt::MigrationHelper
RUBY

inject_into_file 'app/helpers/application_helper.rb', <<RUBY, :after => "module ApplicationHelper\n"
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
RUBY

remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<RUBY
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
RUBY
