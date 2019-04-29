nodejs = node['cwb-workstation']['nodejs']

# Installation based on https://github.com/nodesource/distributions#installation-instructions
# Resources do not run immediately, instead they notify each other
cache_file = File.join(Chef::Config[:file_cache_path], 'setup_nodjs.sh')
remote_file cache_file do
  owner 'root'
  group 'root'
  mode '0644'
  source nodejs['setup_script']
  checksum nodejs['setup_checksum'] if nodejs['setup_checksum']
  action :create
  notifies :run, 'execute[setup_nodejs]', :immediately
end

execute 'setup_nodejs' do
  command "bash #{cache_file}"
  action :nothing
  notifies :install, 'package[nodejs]', :immediately
end

package 'nodejs' do
  action :nothing
end

deploy_user = node['cwb-workstation']['deploy_user']
# Alternatively setup npm properly using  `npm config set prefix ...`
# https://medium.com/@vdeturckheim/install-and-configure-nodejs-and-npm-properly-on-ubuntu-16837d02ecaa
# Attempt to fix global node_modules permissions (for ubuntu deploy user)
# directory '/usr/lib/node_modules/' do
#   owner 'ubuntu'
#   group 'ubuntu'
#   mode '0755'
#   action :create
# end

execute 'update-npm' do
  command 'npm install npm -g'
  user deploy_user
  group deploy_user
  action :run
end

execute 'install-yarn' do
  command 'npm install yarn -g'
  user deploy_user
  group deploy_user
  action :run
end
