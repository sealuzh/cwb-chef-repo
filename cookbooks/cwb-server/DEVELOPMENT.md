# Development

## Requirements

* ChefDK: https://downloads.chef.io/chefdk

## Update this cookbook

1. Bump the version in `metadata.rb`
2. Adjust the `CHANGELOG.md`
3. Run `berks install`
4. Vendor cookbooks with `make vendor`

## Commands

```bash
# Install cookbook dependencies
make install
# Check outdated dependencies
make outdated
# Run integration tests (using Kitchen Dokken) => requires Docker running
make test
# Run all tests
make all_tests
# Run syntax checker
make syntax
```

## Testing

### Integration tests via Docker (as used for Travis CI)

```bash
export KITCHEN_YAML=.kitchen.yml
export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml
kitchen verify

# Show status
kitchen list
# Destroy instance
kitchen destroy
```

See [kitchen-dokken](https://github.com/someara/kitchen-dokken)

### Chef Delivery Local

This cookbook uses (Chef Delivery Local)[https://docs.chef.io/delivery_cli.html#delivery-local] to automate testing stages.

> This feature is currently broken in mono-repos\
> See https://github.com/chef/delivery-cli/issues/47
> Workaround: Use Makefile targets instead

Run all tests:

```bash
delivery local all
```

Individual phases:

```bash
delivery local lint # Cookstyle (Rubocup-based Ruby style linter)
delivery local syntax # Foodcritic (cookbook checker)
delivery local unit # short-running unit tests (rspec + chefspec)
delivery local functional # long-running integration tests
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
