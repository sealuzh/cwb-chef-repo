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
  notifies :run, "execute[unpack #{ruby_with_version}]"
end

bin_dir = File.join(ruby['dir'], 'bin')
execute "unpack #{ruby_with_version}" do
  command "tar xzf #{cache_file} -C #{ruby['dir']}"
  creates File.join(bin_dir, 'ruby')
  action :nothing
  notifies :install, 'gem_package[bundler]'
end

gem_package 'bundler' do
  gem_binary "#{bin_dir}/gem"
  action :nothing
end

# bundler_bin = File.join(bin_dir, 'bundle')
# execute 'install bundler' do
#   command 'gem install bundler'
#   creates bundler_bin
#   action :run
#   not_if { ::File.exist?(bundler_bin) }
# end

# TODO: Consider installing into /usr/bin instead to avoid these path brittlness
# TODO: verify whether this works => DOES NOT WORK: covered by `bundle` test running the first time after install !!!
# Add to path for the current chef-client converge.
# ruby_block "adding '#{bin_dir}' to chef-client ENV['PATH']" do
#   block do
#     ENV['PATH'] = bin_dir + ':' + ENV['PATH']
#     Chef::Log.debug("Added #{bin_dir} to PATH: #{ENV['PATH']}")
#   end
#   # Ensure imdempotence by not adding twice
#   only_if do
#     ENV['PATH'].scan(bin_dir).empty?
#   end
# end

# Add to path for interactive bash sessions
file "/etc/profile.d/#{ruby_with_version}.sh" do
  content "export PATH=#{bin_dir}:$PATH"
  owner 'root'
  group 'root'
  mode '0755'
  action :nothing
end

# ruby_block 'sourcing' do
#   block do
#     cmd = "source '/etc/profile.d/#{ruby_with_version}.sh'"
#     Mixlib::ShellOut.new(cmd).run_command
#     # `source "/etc/profile.d/#{ruby_with_version}.sh"`
#   end
# end
