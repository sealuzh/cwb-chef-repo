### Users
default['cwb-workstation']['deploy_user'] = 'root'

### Chef
# REQUIRED
default['cwb-workstation']['chef']['server_host'] = ''
# REQUIRED
default['cwb-workstation']['chef']['client_key'] = ''
# REQUIRED
default['cwb-workstation']['chef']['validation_key'] = ''

default['cwb-workstation']['chef']['node_name'] = 'cwb-server'
default['cwb-workstation']['chef']['validation_key_name'] = 'chef-validator'

### CWB
# Alternatively: https://github.com/sealuzh/cwb-benchmarks
default['cwb-workstation']['benchmarks_repo'] = 'https://github.com/joe4dev/benchmarks'

### IDE
# Alternatively: 'https://github.com/theia-ide/theia-ruby-extension'
default['cwb-workstation']['ide_repo'] = 'https://github.com/joe4dev/theia-ruby-extension'

### SSH
# Optional (for cwb_ssh utility): Private SSH key to log into other instances launched by CWB
default['cwb-workstation']['ssh_key'] = ''
# Example: ssh-rsa pub_key_goes_here my_key_name
default['cwb-workstation']['pub_key'] = ''

### Nodejs
# Nodejs versions: https://github.com/nodesource/distributions#installation-instructions
default['cwb-workstation']['nodejs']['setup_script'] = 'https://deb.nodesource.com/setup_8.x'
default['cwb-workstation']['nodejs']['setup_checksum'] = nil

### Ruby
default['cwb-workstation']['ruby']['dir'] = '/usr/local'
# Supported versions: https://rvm.io/binaries/ubuntu
# 16.04: https://rvm.io/binaries/ubuntu/18.04/x86_64/
default['cwb-workstation']['ruby']['version'] = '2.4.5'
default['cwb-workstation']['ruby']['bin_dir'] = "#{node['cwb-workstation']['ruby']['dir']}/ruby-#{node['cwb-workstation']['ruby']['version']}/bin"
# Alternatives: http://rubies.travis-ci.org/
default['cwb-workstation']['ruby']['base_url'] = 'https://rvm.io/binaries'
default_source_url = File.join(node['cwb-workstation']['ruby']['base_url'], node['platform'], node['platform_version'], node['kernel']['machine'], "ruby-#{node['cwb-workstation']['ruby']['version']}.tar.bz2")
# Overriding the `source_url` takes precedence over `version`
# Example: https://rvm.io/binaries/ubuntu/18.04/x86_64/ruby-2.4.5.tar.bz2
default['cwb-workstation']['ruby']['source_url'] = default_source_url
# Unchecked if not provided
default['cwb-workstation']['ruby']['checksum'] = nil

### Benchmarks
default['fio']['version'] = '3.13'

### Environment
default['cwb-workstation']['env']['PATH'] = "#{node['cwb-workstation']['ruby']['bin_dir']}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
