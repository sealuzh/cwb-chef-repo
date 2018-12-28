# Workaround for installing Vagrant plugin from source
# Based on: https://github.com/sous-chefs/vagrant/blob/master/libraries/plugin.rb

def username
  node['vagrant']['user']
end

def vagrant_home
  ENV['VAGRANT_HOME'] || ::File.join(home_dir, '.vagrant.d') unless home_dir.nil?
end

def home_dir
  if username
    "/home/#{username}"
  else
    Dir.home
  end
end

# Custom fix of logger spam issue:
# https://github.com/joe4dev/vagrant-butcher
# See (issues with the official version due to merge changes):
# https://github.com/cassianoleal/vagrant-butcher/pull/61
version = '2.3.1'
butcher_file_name = "vagrant-butcher-#{version}.gem"
butcher_path = File.join(home_dir, butcher_file_name)
cookbook_file butcher_path do
  source butcher_file_name
  owner node['cwb-server']['user']
  group node['cwb-server']['user']
  mode '0755'
  action :create
end

vagrant_home_var = vagrant_home
plugin_exists_cmd = "vagrant plugin list | grep 'vagrant-butcher (#{version})'"
execute 'install vagrant-butcher plugin' do
  command "#{plugin_exists_cmd} || vagrant plugin install #{butcher_path}"
  user node['vagrant']['user'] if node['vagrant']['user']
  environment('VAGRANT_HOME' => vagrant_home_var) if vagrant_home_var
end
