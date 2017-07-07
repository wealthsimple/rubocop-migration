require "active_support"
require "active_support/core_ext"
# Only load a portion of strong_migrations
require "strong_migrations/migration"
require "rubocop"

require "rubocop/migration/version"
require "rubocop/cop/migration/add_index_non_concurrently"

module RuboCop
  module Migration
  end
end
