# Development

## Update this cookbook

1. Bump the version in `metadata.rb`
2. Adjust the `CHANGELOG.md`
3. Run `berks install`
4. Vendor cookbooks with `vendor_berks_cookbooks.sh`

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
