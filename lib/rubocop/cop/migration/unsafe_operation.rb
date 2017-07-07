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

        # Ignore `:down` method since those
        def_node_matcher :migration_method_match, <<-PATTERN
          (def {:change :up} args (begin $...))
        PATTERN

        def_node_search :schema_statement_match, <<-PATTERN
          (send nil ${#{SCHEMA_STATEMENTS_PATTERN}} $...)
        PATTERN

        def investigate(processed_source)
          ast = processed_source.ast
          return if !ast || !migration_class?(ast)
          ast.each_child_node do |child_node|
            p child_node
            # migration_method_nodes = migration_method_match(child_node)
            # next unless migration_method_nodes
            # migration_method_nodes.each do |node|
            #   next unless node.send_type? && SCHEMA_STATEMENTS.include?(node.method_name)
            #
            #   method_name = node.method_name
            #   # args =
            #   p "statement:", node, method_name, node.arguments
            # end

            schema_statement_match(child_node) do |method_name, args|
              p "ARGS", method_name, args
            end
          end
        end

      end
    end
  end
end
