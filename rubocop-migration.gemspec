# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubocop/migration/version"

Gem::Specification.new do |spec|
  spec.name          = "rubocop-migration"
  spec.version       = RuboCop::Migration::VERSION
  spec.authors       = ["Peter Graham"]
  spec.email         = ["peter@wealthsimple.com"]

  spec.summary       = %q{RuboCop extension for ActiveRecord migrations.}
  spec.description   = %q{RuboCop extension to catch common pitfalls in ActiveRecord migrations.}
  spec.homepage      = "https://github.com/wealthsimple/rubocop-migration"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "activesupport", ">= 4"
  spec.add_dependency "activerecord", ">= 4"
  spec.add_dependency "strong_migrations", "~> 0.1"
  spec.add_dependency "rubocop", ">= 0.48.0"
  spec.add_dependency "safe_ruby", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2"
  spec.add_development_dependency "pry"
end
