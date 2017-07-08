module RuboCop
  module Cop
    module Migration
      class UnsafeOperation < Cop
        # List of all public methods that can be used within a migration method,
        # like `add_index`, `rename_table`, etc.
        SCHEMA_STATEMENTS = ActiveRecord::ConnectionAdapters::SchemaStatements
          .public_instance_methods
          .freeze
        SCHEMA_STATEMENTS_PATTERN = SCHEMA_STATEMENTS.map { |s| ":#{s}" }.join(" ")

        # Handle `ActiveRecord::Migration` and `ActiveRecord::Migration[5.0]`
        def_node_matcher :migration_class?, <<-PATTERN
          {
            (class
              (const nil _)
              (const
                (const nil :ActiveRecord) :Migration) ...)

            (class
              (const nil _)
              (send
                (const
                  (const nil :ActiveRecord) :Migration) :[] _) ...)
          }
        PATTERN

        def_node_matcher :migration_method_match, <<-PATTERN
          (def {:change :down :up} args $...)
        PATTERN

        def_node_search :schema_statement_match, <<-PATTERN
          $(send nil ${#{SCHEMA_STATEMENTS_PATTERN}} $...)
        PATTERN

        def investigate(processed_source)
          ast = processed_source.ast
          return if !ast || !migration_class?(ast)
          ast.each_child_node do |child_node|
            migration_methods = migration_method_match(child_node)
            migration_methods&.each { |method_node| investigate_migration_method(method_node) }
          end
        end

        private

        def investigate_migration_method(method_node)
          schema_statement_match(method_node) do |statement_node, method_name, args_nodes|
            # TODO: Better/safer way to do this?
            args_source = "[#{args_nodes.map(&:source).join(', ')}]"
            args = eval(args_source)

            checker = RuboCop::Migration::StrongMigrationsChecker.new
            error = checker.check_operation(method_name, *args)
            add_offense(statement_node, :expression, error) if error
          end
        end
      end
    end
  end
end
