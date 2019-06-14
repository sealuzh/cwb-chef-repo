### User
cwb_user = 'cwb'
user cwb_user do
    comment 'The cwb user'
    uid '1234'
    # gid '6789'
    manage_home true
    home '/home/cwb'
    shell '/bin/bash'
end
group cwb_user do
    gid '6789'
    members cwb_user
end

### SSH
ssh_dir = '/home/cwb/.ssh'
directory ssh_dir do
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
pub_key = node['cwb-workstation']['pub_key']
execute "add pub key" do
    command "echo #{pub_key} >> #{ssh_dir}/authorized_keys"
    not_if "grep #{pub_key} #{ssh_dir}/authorized_keys"
end
ssh_key_name = 'cloud-benchmarking.pem'
ssh_key = node['cwb-workstation']['ssh_key']
file ::File.join(ssh_dir, ssh_key_name) do
    content ssh_key
    owner cwb_user
    group cwb_user
    mode '0600'
    action :create
end
# Add `cwb_ssh` script to path as workaround
# to support this helper command in the Theia terminal
# because a helper function does not work there
file '/usr/local/bin/cwb_ssh' do
    content "#!/usr/bin/env bash
    ssh -i #{ssh_dir}/#{ssh_key_name} ubuntu@\$1"
    mode '0755'
    action :create
end

### Chef
chef_dk_version = (node['chef_dk']['version'] rescue 'latest')
chef_dk 'cwb_chef_dk' do
    version chef_dk_version
    action :install
end

chef_dir = '/home/cwb/.chef'
directory chef_dir do
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
template ::File.join(chef_dir, 'config.rb') do
    source 'config.rb.erb'
    variables(
        server_host: node['cwb-workstation']['chef']['server_host'],
        node_name: node['cwb-workstation']['chef']['node_name'],
        validation_key_name: node['cwb-workstation']['chef']['validation_key_name'],
    )
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
file ::File.join(chef_dir, 'chef-validator.pem') do
    content node['cwb-workstation']['chef']['validation_key']
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
file ::File.join(chef_dir, 'cwb-server.pem') do
    content node['cwb-workstation']['chef']['client_key']
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
berkshelf_dir = '/home/cwb/.berkshelf'
directory berkshelf_dir do
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
cookbook_file ::File.join(berkshelf_dir, 'config.json') do
    source 'config.json'
    owner cwb_user
    group cwb_user
    mode '0755'
    action :create
end
