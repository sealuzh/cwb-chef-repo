ruby = node['cwb-server']['ruby']
ruby_with_version = "ruby-#{ruby['version']}"
ruby_tar_file = "#{ruby_with_version}.tar.bz2"

# Required for Ruby gem
package 'libyaml-dev'

# Add Ruby bin to system-wide loaded `/etc/profile.d`: https://askubuntu.com/questions/866161/setting-path-variable-in-etc-environment-vs-profile
# NOTICE: Systemd will NOT automatically pickup this configuration, therefore we also explicitly set the path in the environment (see env attributes)
file '/etc/profile.d/ruby.sh' do
  content "export PATH=\"#{node['cwb-server']['env']['PATH']}\""
  mode '0644'
  owner 'root'
  group 'root'
end

# NOTICE: This resource notifies the `unpack => install bundler` chain
#         such that the installation only updates if the installation file changes
cache_file = File.join(Chef::Config[:file_cache_path], ruby_tar_file)
remote_file cache_file do
  owner 'root'
  group 'root'
  mode '0644'
  source ruby['source_url']
  checksum ruby['checksum'] if ruby['checksum']
  action :create
  notifies :run, "execute[unpack #{ruby_with_version}]", :immediately
end

ruby_bin = File.join(ruby['bin_dir'], 'ruby')
execute "unpack #{ruby_with_version}" do
  command "tar xvjf #{cache_file} -C #{ruby['dir']}"
  creates ruby_bin
  action :nothing
  notifies :run, 'execute[install-bundler]', :immediately
end

execute 'install-bundler' do
  command "#{ruby_bin} -S #{ruby['bin_dir']}/gem install bundler"
  action :nothing
end
