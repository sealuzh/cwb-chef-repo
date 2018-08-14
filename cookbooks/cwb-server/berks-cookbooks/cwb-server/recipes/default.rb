### Base utilities
include_recipe 'cwb-server::attributes'
include_recipe 'cwb-server::users'
include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'git::default'
include_recipe 'timezone_lwrp::default'
include_recipe 'ntp::default'
include_recipe 'cwb-server::dev'

### Installation dependencies
include_recipe 'cwb-server::database'
include_recipe 'cwb-server::ruby_binary'
# Enable when switching from `therubyracer` to `Node` as ExecJS
# include_recipe 'cwb-server::nodejs'

### Runtime dependencies
include_recipe 'cwb-server::nginx'
include_recipe 'vagrant::default'

### Deployment
# Install file permission management utility acl
# used by Capistrano plugin during deployment
# include_recipe 'acl::default'

include_recipe 'cwb-server::secrets'
include_recipe 'cwb-server::deploy'

### TEMPORARY fix for Vagrant <=1.8.1
# Until version >1.8.1 will be released: https://github.com/mitchellh/vagrant/blob/master/CHANGELOG.md
# Fix already merged: https://github.com/mitchellh/vagrant/issues/6158#issuecomment-171352030
file '/usr/bin/vagrant' do
  owner 'root'
  group 'root'
  mode '0755'
  content '#!/usr/bin/env bash
           #
           # This script just forwards all arguments to the real vagrant binary.
           unset RUBYLIB # Temporary fix until Vagrant >1.8.1 is released
           /opt/vagrant/bin/vagrant "$@"'
end
