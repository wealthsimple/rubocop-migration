require "bundler/setup"
require "rubocop-migration"
require "rspec/collection_matchers"
require "rspec/its"
require 'rubocop'
require 'pry' unless ENV["CI"]

rubocop_path = File.join(File.dirname(__FILE__), '../vendor/rubocop')
unless File.directory?(File.join(rubocop_path, '.git'))
  raise("Can't run specs without a local RuboCop checkout. Look in the README.")
end
Dir["#{rubocop_path}/spec/support/**/*.rb"].each { |f| require f }
require 'rubocop/rspec/support'


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
