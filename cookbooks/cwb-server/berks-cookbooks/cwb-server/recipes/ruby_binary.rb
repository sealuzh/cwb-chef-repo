ruby = node['cwb-server']['ruby']
ruby_with_version = "ruby-#{ruby['version']}"

cache_file = File.join(Chef::Config[:file_cache_path], "#{ruby_with_version}.tgz")
# Example: https://s3.amazonaws.com/pkgr-buildpack-ruby/current/ubuntu-14.04/ruby-2.2.4-p230.tgz
default_source = "#{ruby['base_url']}/#{node['platform']}-#{node['platform_version']}/#{ruby_with_version}.tgz"
remote_file cache_file do
  owner 'root'
  group 'root'
  mode '0644'
  source ruby['source_url'] || default_source
  checksum ruby['checksum'] if ruby['checksum']
  action :create
  notifies :run, "execute[unpack #{ruby_with_version}]", :immediately
end

bin_dir = File.join(ruby['dir'], 'bin')
execute "unpack #{ruby_with_version}" do
  command "tar xzf #{cache_file} -C #{ruby['dir']}"
  creates File.join(bin_dir, 'ruby')
  action :nothing
  notifies :install, 'gem_package[bundler]', :immediately
end

gem_package 'bundler' do
  gem_binary "#{bin_dir}/gem"
  action :nothing
end
