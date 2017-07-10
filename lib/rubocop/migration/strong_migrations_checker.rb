module RuboCop
  module Migration
    class StrongMigrationsChecker
      include StrongMigrations::Migration

      # StrongMigrations raises errors for potentially unsafe code, and relies
      # on the user to add a `safety_assured { }` block to supress this warning.
      # These warnings are unsupported by rubocop-migration for now.
      SAFETY_ASSURED_WARNINGS = [
        :add_column_json,
        :add_index_columns,
        :change_table,
        :execute,
        :remove_column,
      ].freeze

      def version_safe?
        false
      end

      def postgresql?
        true
      end

      def check_operation(method_name, *args)
        send(method_name, *args)
      rescue StrongMigrations::UnsafeMigration => e
        strip_wait_message(e.message)
      rescue NoMethodError
        # Do nothing, this method is unrecognized by StrongMigrations unsafe
        # operations and is likely safe.
      end

      private

      def raise_error(message_key)
        return if SAFETY_ASSURED_WARNINGS.include?(message_key)
        super(message_key)
      end

      # Strip large "WAIT!" ASCII art from the StrongMigrations error message.
      def strip_wait_message(error_message)
        error_message.split("\n\n", 2).last
      end
    end
  end
end
