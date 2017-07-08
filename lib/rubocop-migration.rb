require "active_support"
require "active_support/core_ext"
require "active_record"
# Only load a portion of strong_migrations
require "strong_migrations/migration"
require "strong_migrations/unsafe_migration"
require "rubocop"

require "rubocop/migration/version"
require "rubocop/migration/strong_migrations_checker"
require "rubocop/cop/migration/unsafe_migration"

module RuboCop
  module Migration
  end
end
