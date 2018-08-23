nodejs = node['cwb-server']['nodejs']

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
