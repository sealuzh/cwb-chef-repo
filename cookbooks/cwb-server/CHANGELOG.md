# 0.7.5 (2020-06-28)

* Fix new linter warnings
* Fix dependency incompatibility with newer Chef Client Infra version

# 0.7.4 (2020-04-21)

* Add workaround for broken `vagrant-aws` installation (see [vagrant issue](https://github.com/hashicorp/vagrant/issues/11518))
* Fix unpinned bundler version
* Update cookbook dependencies
* Remove workaround for merged vagrant-butcher logger spam

# 0.7.3 (2019-01-03)

* Expose `SSH_PUB_KEY_PATH`
* Fix locale: `en_US.utf8` => `en_US.UTF-8`
* Fix outdated RubyGems

# 0.7.2 (2019-01-02)

* Fix Postgresql locale mismatch in general
* Switch Travis build to Ubuntu 16.04 + Ubuntu 18.04

# 0.7.1 (2018-12-28)

* Fix Postgresql locale mismatch for Ubuntu 18.04 compatibility
* Switch Travis build to Ubuntu 18.04

# 0.7.0 (2018-12-15)

* Add config for Google and Azure providers
* Update dependencies
* Update integration tests

# 0.6.0 (2018-08-17)

Skip 0.5.x to avoid conflict/confusion with stale branch changes.

* Remove legacy Capistrano deployment (were already out commented)
* Fix deployment daemon reload commands

# 0.4.0 (2018-08-14)

* Update deprecated cookbook dependencies that caused failing build (database, windows, timezone-ii => timezone_lwrp, deploy_resource)
* Update Chef deprecations for Chef 14 compatibility

# 0.3.0 (2016-03-27)

Complete rewrite based on the original `cloud-benchmarking-server` cookbook:
* Remove the confusing [databox](https://github.com/teohm/databox-cookbook) and [rackbox](https://github.com/teohm/rackbox-cookbook) app cookbooks => more stable build
* Use precompiled [Ruby](https://packager.io/documentation/ruby/) binaries instead of compiling from source => much faster installation
* Switch from [runit](http://smarden.org/runit/) to [upstart](http://upstart.ubuntu.com/) for managing db and app services => easier administration
* Use [foreman](https://ddollar.github.io/foreman/)-based `Procfile` to manage app services => more transparency what's running
* Add Chef-based [deployment](https://docs.chef.io/resource_deploy.html) as an alternative to [Capistrano](http://capistranorb.com/) => easier deployment
* Add basic integration tests with [Test Kitchen](http://kitchen.ci/) using [Serverspec](http://serverspec.org/resource_types.html) => automate testing
* Update dependencies (e.g., [Vagrant](https://www.vagrantup.com/)) => incorporate all 3rd party improvements
