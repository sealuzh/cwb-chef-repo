apt_update
build_essential

include_recipe 'cwb-workstation::chef_config'
include_recipe 'cwb-workstation::cwb_repo'
include_recipe 'cwb-workstation::benchmarks'
include_recipe 'cwb-workstation::web_ide'
include_recipe 'cwb-workstation::nginx'
