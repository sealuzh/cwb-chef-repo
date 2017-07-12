# cwb-server cookbook

Installs and configures the Cloud WorkBench server.

See (DEVELOPMENT.md)[DEVELOPMENT.md] for developers.

## Supported Platforms

* Ubuntu 16.04 64bit (tested)

## Attributes

See `attributes` directory.

## Usage

### cwb-server::default

Include `cwb-server` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cwb-server]"
  ]
}
```

```ruby
chef.run_list = ['recipe[cwb-server]']
```

```ruby
chef.add_recipe 'cwb-server'
```
