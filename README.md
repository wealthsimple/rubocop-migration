# rubocop-migration [![CircleCI](https://circleci.com/gh/wealthsimple/rubocop-migration.svg?style=svg)](https://circleci.com/gh/wealthsimple/rubocop-migration) [![](https://img.shields.io/gem/v/rubocop-migration.svg)](https://rubygems.org/gems/rubocop-migration)

RuboCop extension to catch common pitfalls in ActiveRecord migrations.

## Installation

Add this line to your application's Gemfile and then execute `bundle`:

```ruby
group :development do
  gem 'rubocop-migration'
end
```

## Usage

Configure RuboCop to load the extension in `.rubocop.yml`.

```yaml
require: rubocop-migration
```

## Development

For running the spec files, this project depends on RuboCop's spec helpers. This means that in order to run the specs locally, you need a (shallow) clone of the RuboCop repository:

```
git clone --depth 1 git://github.com/bbatsov/rubocop.git vendor/rubocop
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## TODO

https://www.braintreepayments.com/blog/safe-operations-for-high-volume-postgresql/
http://leopard.in.ua/2016/09/20/safe-and-unsafe-operations-postgresql
