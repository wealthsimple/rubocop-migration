module RuboCop
  module Migration
    class StrongMigrationsChecker
      include StrongMigrations::Migration

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

      def strip_wait_message(error_message)
        error_message.split("\n\n", 2).last
      end
    end
  end
end
