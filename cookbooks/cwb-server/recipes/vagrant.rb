# Workaround for installing Vagrant plugin from source
# Based on: https://github.com/sous-chefs/vagrant/blob/master/libraries/plugin.rb

version = '2.3.1'
butcher_path = "#{Chef::Config[:file_cache_path]}/cookbooks/cwb-server/files/default/vagrant-butcher-#{version}.gem"

def username
  node['vagrant']['user']
end

def vagrant_home
  user_home_dir = home_dir
  ENV['VAGRANT_HOME'] || ::File.join(user_home_dir, '.vagrant.d') unless user_home_dir.nil?
end

def home_dir
  return Dir.home unless username
  # Unix only!
  begin
    Dir.home(username)
  rescue ArgumentError
    Chef::Log.warn('[recipes/vagrant] User not found: Cannot determine home directory for Vagrant!')
  end
end

vagrant_home_var = vagrant_home
plugin_exists_cmd = "vagrant plugin list | grep 'vagrant-butcher (#{version})'"
execute 'install vagrant-butcher plugin' do
  command "#{plugin_exists_cmd} || (vagrant plugin install #{butcher_path}; echo 'INSTALLED butcher'>/home/apps/test.log)"
  user node['vagrant']['user'] if node['vagrant']['user']
  environment('VAGRANT_HOME' => vagrant_home_var) if vagrant_home_var
end
