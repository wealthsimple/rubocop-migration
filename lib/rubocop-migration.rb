require "active_support"
require "active_support/core_ext"
require "active_record"
# Only load a portion of strong_migrations
require "strong_migrations/migration"
require "rubocop"

require "rubocop/migration/version"
require "rubocop/cop/migration/unsafe_operation"

module RuboCop
  module Migration
  end
end
