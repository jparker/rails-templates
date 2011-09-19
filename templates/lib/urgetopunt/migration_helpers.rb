module Urgetopunt
  module MigrationHelpers
    def add_foreign_key_constraint(table, column, options = {})
      ref_table = options[:ref_table] || column.to_s.sub(/_id$/, '').tableize
      ref_column = options[:ref_column] || :id
      indexable = options.has_key?(:index) ? options[:index] : true

      execute <<-SQL.squish
        ALTER TABLE      \#{connection.quote_table_name table}
        ADD FOREIGN KEY (\#{connection.quote_column_name column})
        REFERENCES       \#{connection.quote_table_name ref_table}(\#{connection.quote_column_name ref_column})
      SQL
      add_index table, column if indexable
    end

    def remove_foreign_key_constraint(table, column, options = {})
      indexable = options.has_key?(:index) ? options[:index] : true
      remove_index table, column if indexable
      execute "ALTER TABLE \#{connection.quote_table_name table} DROP CONSTRAINT \#{table}_\#{column}_fkey"
    end
  end
end
