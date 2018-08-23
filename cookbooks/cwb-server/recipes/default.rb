### Base utilities
include_recipe 'cwb-server::detect_host'
include_recipe 'cwb-server::users'
apt_update
build_essential 'install build essentials' do
  compile_time true
end
include_recipe 'git::default'
include_recipe 'timezone_lwrp::default'
include_recipe 'ntp::default'
include_recipe 'cwb-server::dev'

### Installation dependencies
include_recipe 'cwb-server::database'
# Alternatively use maintained Ubuntu packages: https://www.brightbox.com/docs/ruby/ubuntu/
include_recipe 'cwb-server::ruby_binary'
include_recipe 'cwb-server::nodejs'

### Runtime dependencies
include_recipe 'cwb-server::nginx'
include_recipe 'vagrant::default'
# Workaround for #37 and #59 (merged): https://github.com/cassianoleal/vagrant-butcher
# include_recipe 'cwb-server::vagrant'

include_recipe 'cwb-server::secrets'
include_recipe 'cwb-server::deploy'
