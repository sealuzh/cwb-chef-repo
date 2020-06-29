# cwb-server cookbook

[![Build Status](https://travis-ci.org/sealuzh/cwb-chef-repo.svg?branch=master)](https://travis-ci.org/sealuzh/cwb-chef-repo)

Installs and configures the Cloud WorkBench server.

## Supported Platforms

* Ubuntu 18.04 64bit (manually tested 2019-01-02 and monthly tested through CI build)
* Ubuntu 20.04 64bit (monthly tested through CI build)
* NOTE: Ubuntu 16.04 fails due to a an [issue](https://github.com/chef-cookbooks/ntp/issues/177) with the ntp recipe

Ensure that the default locale `en_US.UTF-8` exists (e.g., install via `sudo locale-gen en_US.UTF-8`) or configure via the attribute `cwb-server.system.locale`

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
