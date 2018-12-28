# cwb-server cookbook

[![Build Status](https://travis-ci.org/sealuzh/cwb-chef-repo.svg?branch=master)](https://travis-ci.org/sealuzh/cwb-chef-repo)

Installs and configures the Cloud WorkBench server.


## Supported Platforms

* Ubuntu 18.04 64bit (tested 2018-12-28)
* Ubuntu 16.04 64bit (tested 2018-12-28)

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
