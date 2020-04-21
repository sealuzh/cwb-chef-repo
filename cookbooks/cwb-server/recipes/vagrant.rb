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

# Custom fix for broken vagrant-aws installation:
# https://github.com/hashicorp/vagrant/issues/11518
# => Should be fixed after release of Vagrant 2.2.8 but then the following kicks in:
# https://github.com/mitchellh/vagrant-aws/issues/566
# Based on a fork copied to: https://github.com/joe4dev/vagrant-aws
version = '0.7.3'
vagrant_aws_file_name = "vagrant-aws-#{version}.gem"
vagrant_aws_path = File.join(home_dir, vagrant_aws_file_name)
cookbook_file vagrant_aws_path do
  source vagrant_aws_file_name
  owner node['cwb-server']['user']
  group node['cwb-server']['user']
  mode '0755'
  action :create
end

vagrant_home_var = vagrant_home
plugin_exists_cmd = "vagrant plugin list | grep 'vagrant-aws (#{version})'"
execute 'install vagrant-aws plugin' do
  command "#{plugin_exists_cmd} || vagrant plugin install #{vagrant_aws_path}"
  user node['vagrant']['user'] if node['vagrant']['user']
  environment('VAGRANT_HOME' => vagrant_home_var) if vagrant_home_var
end
