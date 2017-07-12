# Fixes the missing `libyaml` dependency causing the error:
# ```
# It seems your ruby installation is missing psych (for YAML output).
# To eliminate this warning, please install libyaml and reinstall your ruby.
# ```
package 'libyaml-dev'

# Packages required to build native extensions (e.g., for `nio4r` in Rails)
## Listing dependencies: https://gorails.com/setup/ubuntu/16.04
package 'ruby-dev'
# package 'zlib1g-dev'

ruby = node['cwb-server']['ruby']
ruby_with_version = "ruby-#{ruby['version']}"
cache_file = File.join(Chef::Config[:file_cache_path], "#{ruby_with_version}.tgz")
install_dir = File.join(ruby['dir'], 'bin')
ruby_home = File.join(ruby['dir'], ruby_with_version)
bin_path = "#{ruby_home}/bin"

# This also affects the current Chef run because it's
# run via `run_action(:run)` at compile time.
modify_path = ruby_block 'Add new Ruby to PATH' do
  block do
    ENV['PATH'] = "#{bin_path}:#{ENV['PATH']}"
  end
end
modify_path.run_action(:run)

# Example: https://rvm.io/binaries/ubuntu/16.04/x86_64/ruby-2.4.1.tar.bz2
default_source = "#{ruby['base_url']}/#{node['platform']}/#{node['platform_version']}/#{ruby['target_arch']}/#{ruby_with_version}.tar.bz2"
remote_file 'download-ruby' do
  path cache_file
  owner 'root'
  group 'root'
  mode '0644'
  source ruby['source_url'] || default_source
  checksum ruby['checksum'] if ruby['checksum']
  action :create
  notifies :run, "execute[unpack-ruby]", :immediately
end

execute "unpack-ruby" do
  command "tar xjf #{cache_file} -C #{ruby['dir']}"
  action :nothing
end

# NOTICE: `gem_package 'bundler'` with `gem_binary "#{ruby_home}/bin/gem"` didn't work
# because the wrong Ruby gem installation was chosen (i.e., the Chef embedded Ruby)
bundle_exists = "test -f #{ruby_home}/bin/bundle"
execute 'install-bundler' do
  command 'gem install bundler'
  # Use custom Ruby by removing `/opt/chef/embedded/bin` from the path: https://github.com/chef/chef/pull/6014
  environment(PATH: ENV['PATH'])
  not_if bundle_exists
  action :run
end

%w(ruby gem bundle ruby_executable_hooks).each do |bin|
  link "#{install_dir}/#{bin}" do
    to "#{ruby_home}/bin/#{bin}"
    action :create
  end
end
