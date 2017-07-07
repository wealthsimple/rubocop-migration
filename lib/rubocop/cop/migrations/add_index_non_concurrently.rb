module RuboCop
  module Cop
    module Migrations
      class AddIndexNonConcurrently < Cop
        MSG = 'Use `algorithm: :concurrently` to avoid locking database.'.freeze

        def_node_matcher :add_index_or_add_reference?, <<-PATTERN
          (send nil {:add_index :add_reference} ...)
        PATTERN

        def on_send(node)
          if add_index_or_add_reference?(node)
            options = options_hash(node)
            if !options[:algorithm].present? || options[:algorithm] != "concurrently"
              add_offense(node, :expression, MSG)
            end
          end
        end

        private

        def options_hash(node)
          options = {}
          node.children.each do |c|
            if c.is_a?(AST::Node) && c.type == :hash
              c.each_pair do |key_node, value_node|
                options[key_node.children.first.to_sym] = value_node.children.first.to_s
              end
            end
          end
          options
        end
      end
    end
  end
end
