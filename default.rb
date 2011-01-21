apply File.join(File.dirname(__FILE__), 'pre.rb')

# TODO: move to urgetopunt_rails_helper gem
initializer 'urgetopunt.rb', <<RUBY
require 'urgetopunt/migration_helpers'
RUBY
lib 'urgetopunt/migration_helpers.rb', <<RUBY
module Urgetopunt
  module MigrationHelper
    # add_foreign_key_constraint :items, :seller_id             # items.seller_id => sellers.id
    # add_foregin_key_constraint :messages, :sender_id, :people # messages.sender_id => people.id
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

apply File.join(File.dirname(__FILE__), 'post.rb')
