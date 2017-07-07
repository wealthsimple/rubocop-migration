module RuboCop
  module Cop
    module Migration
      class AddIndexNonConcurrently < Cop
        MSG = 'Use `algorithm: :concurrently` to avoid locking table.'.freeze

        def_node_matcher :add_index_match, <<-PATTERN
          (send nil :add_index _ _ (hash $...))
        PATTERN

        def_node_matcher :add_reference_match, <<-PATTERN
          (send nil {:add_reference :add_belongs_to} _ _ (hash $...))
        PATTERN

        def_node_matcher :add_reference_index_options?, <<-PATTERN
          (pair (sym :index) !({:nil false}))
        PATTERN

        def on_send(node)
          if node.method_name == :add_index
            check_add_index(node)
          elsif [:add_reference, :add_belongs_to].include?(node.method_name)
            check_add_reference(node)
          end
        end

        private

        def check_add_index(node)
          pairs = add_index_match(node)
          if !pairs_contains_algorithm_concurrently?(pairs)
            add_offense(node, :expression, MSG)
          end
        end

        def check_add_reference(node)
          pairs = add_reference_match(node)
          index_options = pairs&.find { |pair| add_reference_index_options?(pair) }&.value
          return unless index_options

          valid = true
          if index_options.true_type?
            # `index: true` is always invalid
            valid = false
          elsif index_options.hash_type?
            # check for `algorithm: :concurrently`
            valid = pairs_contains_algorithm_concurrently?(index_options.pairs)
          end
          add_offense(node, :expression, MSG) if !valid
        end

        def pairs_contains_algorithm_concurrently?(pairs)
          return false unless pairs.is_a?(Array)
          pairs.each do |pair|
            next unless pair.pair_type?
            key = pair.key
            value = pair.value
            next unless (key.sym_type? || key.str_type?) && key.children.first.to_s == "algorithm"
            return true if value.children.first.to_s == "concurrently"
          end
          false
        end
      end
    end
  end
end
