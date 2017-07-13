### Devtools
# Must be available via package manager
default['cwb-server']['dev']['tools'] = %w(vim curl)

### App
default['cwb-server']['app']['name'] = 'cloud-workbench'
default['cwb-server']['app']['user_password'] = 'demo'
default['cwb-server']['app']['user'] = 'apps'
default['cwb-server']['app']['deploy_user'] = 'deploy'
default['cwb-server']['app']['dir'] = '/var/www/cloud-workbench'
# Upstart logs to `/var/log/APPNAME` by convention
default['cwb-server']['app']['log_dir'] = "/var/log/#{node['cwb-server']['app']['name']}"
default['cwb-server']['app']['repo'] = 'https://github.com/sealuzh/cloud-workbench.git'
# A branch, tag, or commit to be synchronized with git
default['cwb-server']['app']['branch'] = 'master'
default['cwb-server']['app']['rollback_on_error'] = false
default['cwb-server']['app']['num_workers'] = 2
# Should be a multiple of 1000 according to foreman: http://ddollar.github.io/foreman/#EXPORTING
default['cwb-server']['app']['port'] = 3000

### Nginx
# Defaults to `0.0.0.0` if unset
default['cwb-server']['nginx']['hostname'] = nil
default['cwb-server']['nginx']['log_dir'] = '/var/log/nginx'

### Providers
# Vagrant providers: https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers
# a) Optimistic (might break on newer releases): ['vagrant-google', ...]
# b) Pessimistic (requires manual updating): [{ 'name' => 'vagrant-google',  'version' =>  '0.2.2' }, ...]
default['cwb-server']['vagrant']['providers'] = [
  { 'name' => 'vagrant-aws', 'version' => '0.7.2' },
  { 'name' => 'vagrant-azure', 'version' => '2.0.0.pre8' },
  { 'name' => 'vagrant-google', 'version' => '0.2.5' },
]

### Ruby
default['cwb-server']['ruby']['dir'] = '/usr/local'
default['cwb-server']['ruby']['version'] = '2.4.1'
default['cwb-server']['ruby']['base_url'] = 'https://rvm.io/binaries'
default['cwb-server']['ruby']['target_arch'] = 'x86_64'
# Full URL to Ruby binary. Example: https://rvm.io/binaries/ubuntu/16.04/x86_64/ruby-2.4.1.tar.bz2
# `source_url` takes precedence over `version`
default['cwb-server']['ruby']['source_url'] = nil
# Unchecked if not provided
default['cwb-server']['ruby']['checksum'] = nil

### Nodejs
# Nodejs versions: https://github.com/nodesource/distributions#installation-instructions
default['cwb-server']['nodejs']['setup_script'] = 'https://deb.nodesource.com/setup_5.x'
default['cwb-server']['nodejs']['setup_checksum'] = nil

### Database
default['cwb-server']['db']['name'] = 'cloud_workbench_production'
default['cwb-server']['db']['user'] = 'cloud'
# Randomly generated if not provided
default['cwb-server']['db']['password'] = nil

### Environment variables
default['cwb-server']['env']['HOME'] = "/home/#{node['cwb-server']['app']['user']}"
default['cwb-server']['env']['RAILS_ENV'] = 'production'
# Enable this when switching from therubyracer to Node
# default['cwb-server']['env']['EXECJS_RUNTIME'] = 'Node'
# Randomly generated if not provided
default['cwb-server']['env']['SECRET_KEY_BASE'] = nil
# Dynamic example: [node['cpu']['total'].to_i * 4, 8].min
default['cwb-server']['env']['WEB_CONCURRENCY'] = 3

default['cwb-server']['host_detection'] = 'wget -qO- http://ipecho.net/plain; echo'
default['cwb-server']['env']['CWB_SERVER_HOST'] = nil

### Secrets
default['cwb-server']['apply_secret_config'] = true

# SSH
default['cwb-server']['ssh']['key'] = '-----BEGIN RSA PRIVATE KEY-----'
default['cwb-server']['ssh']['key_name'] = 'cloud-benchmarking'

# Chef
default['cwb-server']['chef']['node_name'] = 'cwb-server'
default['cwb-server']['chef']['client_key'] = '-----BEGIN RSA PRIVATE KEY-----'
default['cwb-server']['chef']['client_key_name'] = 'cwb-server'
default['cwb-server']['chef']['validation_key'] = '-----BEGIN RSA PRIVATE KEY-----'
default['cwb-server']['chef']['validation_key_name'] = 'chef-validator'
default['cwb-server']['chef']['server_host'] = '33.33.33.10'
server_host = node['cwb-server']['chef']['server_host']
validation_key_name = node['cwb-server']['chef']['validation_key_name']
# Infer organization from validation_key_name
organisation = validation_key_name.chomp('-validator')
default['cwb-server']['chef']['server_url'] = "https://#{server_host}:443/organizations/#{organisation}"

# Chef VM provisioning
# Latest version known to work properly: '12.2.1'
# Some newer versions break certain cookbooks
# (e.g. postgresql: https://github.com/hw-cookbooks/postgresql/issues/212)\
# TODO: Fix this !!! => bump Chef version (e.g., to 13.2.20)
default['cwb-server']['chef']['omnibus_chef_version'] = '12.2.1'
default['cwb-server']['chef']['provisioning_path'] = '/etc/chef'

## Providers
# Initialize providers hash
default['cwb-server']['providers'] = {}

# Conventions:
# Use the vagrant provider name as namespace (e.g., aws)
# ['aws']['access_key'] will be exposed as `AWS_ACCESS_KEY` (environment variable)
# _BASE64: decodes the given string with base64 (useful for binary key files)
# _FILE: stores the key into a file and exposes a path variable
#  Example: ['google']['api_key_BASE64_FILE']
# 1) Decode the given string with base64
# 2) Store decoded content within `google/API_KEY_NAME.pem` using
#    ['google']['api_key_name'] as filename (default: provider name)
# 3) Expose the file path as `GOOGLE_API_KEY_PATH`

# AWS (example)
# default['cwb-server']['providers']['aws']['access_key'] = ''
# default['cwb-server']['providers']['aws']['secret_key'] = ''

# Google (example)
# default['cwb-server']['providers']['google']['project_id'] = ''
# default['cwb-server']['providers']['google']['client_email'] = ''
# default['cwb-server']['providers']['google']['api_key_name'] = ''
# default['cwb-server']['providers']['google']['api_key_BASE64_FILE'] = ''
