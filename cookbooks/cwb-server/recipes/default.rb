### Base utilities
include_recipe 'cwb-server::attributes'
include_recipe 'cwb-server::users'
include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'git::default'
include_recipe 'timezone-ii::default'
include_recipe 'ntp::default'
include_recipe 'cwb-server::dev'

### Installation dependencies
include_recipe 'cwb-server::database'
include_recipe 'cwb-server::ruby_binary'
# Enable when switching from `therubyracer` to `Node` as ExecJS
# include_recipe 'cwb-server::nodejs'

### Runtime dependencies
include_recipe 'cwb-server::nginx'
include_recipe 'vagrant::default'

include_recipe 'cwb-server::secrets'
include_recipe 'cwb-server::deploy'
