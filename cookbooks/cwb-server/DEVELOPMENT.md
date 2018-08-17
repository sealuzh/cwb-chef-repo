# Development

## Integration Testing

```
kitchen verify
```

## Lint

```
foodcritic .
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
