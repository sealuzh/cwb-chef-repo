ruby = node['cwb-server']['ruby']
ruby_with_version = "ruby-#{ruby['version']}"
ruby_tar_file = "#{ruby_with_version}.tar.bz2"
def ruby_bin(ruby)
  File.join(ruby['bin_dir'], 'ruby')
end

def ruby_cmd(ruby, cmd)
  "#{ruby_bin(ruby)} -S #{ruby['bin_dir']}/#{cmd}"
end

# Required for Ruby (see dependency list: https://gorails.com/setup/ubuntu/16.04)
# Fixes the missing `libyaml` dependency causing the error:
# ```
# It seems your ruby installation is missing psych (for YAML output).
# To eliminate this warning, please install libyaml and reinstall your ruby.
# ```
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
remote_file 'download-ruby' do
  path cache_file
  owner 'root'
  group 'root'
  mode '0644'
  source ruby['source_url']
  checksum ruby['checksum'] if ruby['checksum']
  action :create_if_missing
  notifies :run, "execute[unpack #{ruby_with_version}]", :immediately
end

ruby_bin = ruby_bin(ruby)
execute "unpack #{ruby_with_version}" do
  command "tar xvjf #{cache_file} -C #{ruby['dir']}"
  creates ruby_bin
  action :nothing
  notifies :run, 'execute[update-ruby-gems]', :immediately
end

# Only update once whenever notified from a newly unpacked ruby
update_ruby_gems_cmd = ruby_cmd(ruby, 'gem update --system')
execute 'update-ruby-gems' do
  command update_ruby_gems_cmd
  action :nothing
end

# This also affects the current Chef run because it's
# run via `run_action(:run)` at compile time.
# modify_path = ruby_block 'Add new Ruby to PATH' do
#   block do
#     ENV['PATH'] = "#{ruby_bin}:#{ENV['PATH']}"
#   end
# end
# modify_path.run_action(:run)

bundle_exist = "test -f #{ruby['bin_dir']}/bundle"
install_bundler_cmd = ruby_cmd(ruby, 'gem install bundler')
execute 'install-bundler' do
  command install_bundler_cmd
  not_if bundle_exist
  action :run
end

hooks_exist = "test -f #{ruby['bin_dir']}/ruby_executable_hooks"
install_ruby_hooks_cmd = ruby_cmd(ruby, 'gem install --user-install executable-hooks')
execute 'install-ruby-executable-hooks' do
  command install_ruby_hooks_cmd
  not_if hooks_exist
  action :run
end

# Symlink Ruby executables => should not be necessary given correct path settings
# %w(ruby gem bundle ruby_executable_hooks).each do |executable|
#   link "/usr/local/bin/#{executable}" do
#     to File.join(ruby['bin_dir'], executable)
#     action :create
#   end
# end
