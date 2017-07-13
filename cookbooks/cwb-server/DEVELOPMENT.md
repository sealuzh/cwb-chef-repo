# Development

## Requirements

* ChefDK: https://downloads.chef.io/chefdk
* Install Gemfile dependencies: `bundle install`

## Update this cookbook

1. Bump the version in `metadata.rb`
2. Adjust the `CHANGELOG.md`
3. Run `berks install`
4. Vendor cookbooks with `vendor_berks_cookbooks.sh`

## Testing

```bash
cookstyle # Cookbook linting (Rubocup config for cookbooks)
foodcritic . # Cookbook checker
chef exec rspec spec/ # short-running unit tests (Rspec + ChefSpec)
chef exec kitchen verify # long-running integration tests (TestKitchen)

# Integration tests via Docker (as used for Travis CI)
KITCHEN_LOCAL_YAML=.kitchen.dokken.yml chef exec kitchen verify
```

### Cleanup Integration Tests

```
chef exec kitchen destroy
```

## Debugging Vagrantfile

Requires a [readline](https://en.wikipedia.org/wiki/GNU_Readline) implementation:
```bash
brew install readline               # C (native)
vagrant plugin install rb-readline  # Ruby
```

Install pry: http://pryrepl.org/
```bash
vagrant plugin install pry
```

Start a REPL session
```ruby
require 'pry';
binding.pry
```
