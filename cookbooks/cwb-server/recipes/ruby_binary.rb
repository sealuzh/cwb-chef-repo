ruby = node['cwb-server']['ruby']
ruby_with_version = "ruby-#{ruby['version']}"
ruby_tar_file = "#{ruby_with_version}.tar.bz2"

# Required for Ruby gem
package 'libyaml-dev'

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
  # notifies :install, 'gem_package[bundler]', :immediately
end

# TODO: only for debug, no notify mechanism
execute 'install bundler' do
  command "#{ruby_bin} -S #{ruby['bin_dir']}/gem install bundler"
end

# TODO: fails to install bundler
# gem_package 'bundler' do
#   gem_binary "#{node['cwb-server']['ruby']['bin_dir']}/gem"
#   options "#{node['cwb-server']['ruby']['bin_dir']}"
#   action :install
# end
