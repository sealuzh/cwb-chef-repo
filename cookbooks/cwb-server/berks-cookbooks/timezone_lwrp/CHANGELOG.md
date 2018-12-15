# cookbook `timezone` CHANGELOG

## 0.2.2 (22-11-2018)

* Informational release
* The resource was merged to the Chef client v14.6.47, so the future support of this cookbook will be stopped. Please consider an upgrade to an up-to-date Chef client version.

## 0.2.1 (01-08-2018)

* Small resource refactoring (thanks to @tas50);
* More platforms for testing/support;
  * Ubuntu 18.04
  * Amazon Linux 2017.03
  * Amazon Linux 2
  * openSUSE Leap 42

## 0.2.0 (04-04-2018)

* Chef 14 support was tested and enabled;
* LWRP resource was changed to the new style chef custom resource;
* TravisCI was configured to run Kitchen CI in its own Docker service;
* Bundle update;

## 0.1.12

* Rubocop & foodcritic code style fixes.
* Test Kitchen: verifier was switched to InSpec.
* Test Kitchen: the list of test platforms was updated, no more outdated ones:
  * Ubuntu 14.04
  * Ubuntu 16.04
  * Debian 8
  * Debian 9
  * Centos 6
  * Centos 7
  * Fedora 26
  * Fedora 27
* TravisCI: new ruby & secrets.

## 0.1.11

* Fixed support for RedHat 7.
* Verion constraint for fedora was removed.

## 0.1.10 (28-08-206)

* Test Kitchen: fix vagrant options for Ubuntu Xenial to work.
* Test Kitchen: fix image names for DigitalOcean for TravisCI builds.
* Chef::Provider::TimezoneLwrp fix current timezone check


## 0.1.9 (26-08-2016)

* Fix Test Kitchen run on Fedora >= 22.

## 0.1.8 (25-08-2016)

* Ubuntu 16.04 & Debian 8 support.

## 0.1.7 (09-10-2015)

* Compatibility with Chef 12.4.0 and older.

## 0.1.6 (13-04-2015)

* Travis-CI integration.

## 0.1.5 (11-04-2015)

* Small README file fix.

## 0.1.4 (10-04-2015)

* support for CentOS, Fedora, RHEL
* you can use this cookbook as an attribute-based now, if you want
* a bit of chefspec

## 0.1.3 (07-04-2015)

* forked and renamed for uploading into Supermarket.

## 0.1.2 (06-04-2015)

* Actual inter-resource notifications fix.
* Test Kitchen & ServerSpec integration.

## 0.1.1 (21-05-2014)

* First try to fix inter-resource notifications.

## 0.1.0 (23-12-2013)

* Initial release
