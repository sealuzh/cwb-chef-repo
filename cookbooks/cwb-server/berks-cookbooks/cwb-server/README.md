# cwb-server cookbook

[![Build Status](https://travis-ci.org/sealuzh/cwb-chef-repo.svg?branch=master)](https://travis-ci.org/sealuzh/cwb-chef-repo)

Installs and configures the Cloud WorkBench server.

## Supported Platforms

* Ubuntu 18.04 64bit (tested 2019-01-02)
* Ubuntu 16.04 64bit (tested 2019-01-02)

Ensure that the default locale `en_US.utf8` exists or configure via the attribute `cwb-server.system.locale`

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
