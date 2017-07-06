# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "egad/version"

Gem::Specification.new do |spec|
  spec.name          = "egad"
  spec.version       = Egad::VERSION
  spec.authors       = ["Peter Graham"]
  spec.email         = ["peter@wealthsimple.com"]

  spec.summary       = %q{Identify common Ruby/Rails pitfalls in your code.}
  spec.description   = %q{Identify common Ruby/Rails pitfalls in your codebase.}
  spec.homepage      = "https://github.com/wealthsimple/egad"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "activesupport", "5.1.1"
  spec.add_dependency "cri", "2.9.1"
  spec.add_dependency "paint", "2.0.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2"
end
