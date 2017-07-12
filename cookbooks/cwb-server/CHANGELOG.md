# 0.5.0 (2017-07-08)

* Bump all cookbook dependencies
* Add Chef 13 compatibility
* Add support for Ubuntu 16.04
    * Switch from upstart to systemd process management
* Use RVM Ruby binaries
* Update to Ruby `2.4.1`
* Remove Capistrano dependencies (were already out-commented)

# 0.4.0 (2017-04-02)

* Update to Ruby `2.3.0` to fix buggy outdated Ruby version
* Update Vagrant cookbook
* Remove temporary fix for Vagrant <= 1.8.1
* Loosen common cookbook (e.g., `apt`) constraints to avoid conflicts

# 0.3.0 (2016-03-27)

Complete rewrite based on the original `cloud-benchmarking-server` cookbook:
* Remove the confusing [databox](https://github.com/teohm/databox-cookbook) and [rackbox](https://github.com/teohm/rackbox-cookbook) app cookbooks => more stable build
* Use precompiled [Ruby](https://packager.io/documentation/ruby/) binaries instead of compiling from source => much faster installation
* Switch from [runit](http://smarden.org/runit/) to [upstart](http://upstart.ubuntu.com/) for managing db and app services => easier administration
* Use [foreman](https://ddollar.github.io/foreman/)-based `Procfile` to manage app services => more transparency what's running
* Add Chef-based [deployment](https://docs.chef.io/resource_deploy.html) as an alternative to [Capistrano](http://capistranorb.com/) => easier deployment
* Add basic integration tests with [Test Kitchen](http://kitchen.ci/) using [Serverspec](http://serverspec.org/resource_types.html) => automate testing
* Update dependencies (e.g., [Vagrant](https://www.vagrantup.com/)) => incorporate all 3rd party improvements
