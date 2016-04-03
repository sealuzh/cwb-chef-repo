# List of commercial addons: https://github.com/chef-cookbooks/chef-server#attributes
node.default['chef-server']['addons'] = []

include_recipe 'chef-server::default'
include_recipe 'chef-server::addons'
