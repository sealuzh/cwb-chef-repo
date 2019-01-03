### System
default['cwb-server']['system']['locale'] = 'en_US.UTF-8'

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
default['cwb-server']['nginx']['hostname'] = '0.0.0.0'
default['cwb-server']['nginx']['log_dir'] = '/var/log/nginx'

### Providers
# Vagrant providers: https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers
# a) Optimistic (might break on newer releases): ['vagrant-google', ...]
# b) Pessimistic (requires manual updating): [{ 'name' => 'vagrant-google',  'version' =>  '0.2.2' }, ...]
default['cwb-server']['vagrant']['providers'] = [
  { 'name' => 'vagrant-aws', 'version' => '0.7.2' },
  { 'name' => 'vagrant-google', 'version' => '2.2.1' },
  { 'name' => 'vagrant-azure', 'version' => '2.0.0' },
]

### Vagrant: https://supermarket.chef.io/cookbooks/vagrant#readme
default['vagrant']['version'] = '2.1.2'
default['vagrant']['user'] = node['cwb-server']['app']['user']
default['vagrant']['plugins'] = [
  # Ensure that Chef is installed within a VM
  { 'name' => 'vagrant-omnibus', 'version' => '1.5.0' },
  # Delete Chef client and node when destroying a VM
  # Issue with 2.3.0: https://github.com/cassianoleal/vagrant-butcher/issues/37
  { 'name' => 'vagrant-butcher', 'version' => '2.3.0' },
] + node['cwb-server']['vagrant']['providers']

### Ruby
default['cwb-server']['ruby']['dir'] = '/usr/local'
# Supported versions: https://rvm.io/binaries/ubuntu
# 16.04: https://rvm.io/binaries/ubuntu/16.04/x86_64/
default['cwb-server']['ruby']['version'] = '2.5.1'
default['cwb-server']['ruby']['bin_dir'] = "#{node['cwb-server']['ruby']['dir']}/ruby-#{node['cwb-server']['ruby']['version']}/bin"
# Alternatives: http://rubies.travis-ci.org/
default['cwb-server']['ruby']['base_url'] = 'https://rvm.io/binaries'
default_source_url = File.join(node['cwb-server']['ruby']['base_url'], node['platform'], node['platform_version'], node['kernel']['machine'], "ruby-#{node['cwb-server']['ruby']['version']}.tar.bz2")
# Overriding the `source_url` takes precedence over `version`
# Example: https://rvm.io/binaries/ubuntu/16.04/x86_64/ruby-2.2.5.tar.bz2
default['cwb-server']['ruby']['source_url'] = default_source_url
# Unchecked if not provided
default['cwb-server']['ruby']['checksum'] = nil

### Nodejs
# Nodejs versions: https://github.com/nodesource/distributions#installation-instructions
default['cwb-server']['nodejs']['setup_script'] = 'https://deb.nodesource.com/setup_10.x'
default['cwb-server']['nodejs']['setup_checksum'] = nil

### Database
default['cwb-server']['db']['postgres_password'] = 'rootcloud'
default['cwb-server']['db']['postgresql_version'] = '9.6'
default['cwb-server']['db']['port'] = 5432
default['cwb-server']['db']['name'] = 'cloud_workbench_production'
default['cwb-server']['db']['user'] = 'cloud'
default['cwb-server']['db']['password'] = 'cloud'

### Environment variables
default['cwb-server']['env']['HOME'] = "/home/#{node['cwb-server']['app']['user']}"
default['cwb-server']['env']['RAILS_ENV'] = 'production'
default['cwb-server']['env']['RAILS_LOG_TO_STDOUT'] = 'true'
default['cwb-server']['env']['LOG_LEVEL'] = 'info'
default['cwb-server']['env']['EXECJS_RUNTIME'] = 'Node'
# Randomly generated if not provided
default['cwb-server']['env']['SECRET_KEY_BASE'] = nil
# Dynamic example: [node['cpu']['total'].to_i * 4, 8].min
default['cwb-server']['env']['WEB_CONCURRENCY'] = 3

default['cwb-server']['host_detection'] = 'wget -qO- http://ipecho.net/plain; echo'
default['cwb-server']['env']['CWB_SERVER_HOST'] = nil
default['cwb-server']['env']['PATH'] = "#{node['cwb-server']['ruby']['bin_dir']}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

### Secrets
default['cwb-server']['apply_secret_config'] = true

# SSH
default['cwb-server']['ssh']['key'] = '-----BEGIN RSA PRIVATE KEY-----'
default['cwb-server']['ssh']['pub_key'] = ''
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
# Chef client versions: https://docs.chef.io/release_notes.html
# Notice that CWB is currently not yet compatible with Chef 13 and 14
# https://github.com/sealuzh/cwb-benchmarks/issues/20
default['cwb-server']['chef']['omnibus_chef_version'] = '12.22.3'
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

# Azure (example)
# default['cwb-server']['providers']['azure']['tenant_id'] = ''
# default['cwb-server']['providers']['azure']['client_id'] = ''
# default['cwb-server']['providers']['azure']['client_secret'] = ''
# default['cwb-server']['providers']['azure']['subscription_id'] = ''

# Google (example)
# default['cwb-server']['providers']['google']['project_id'] = ''
# default['cwb-server']['providers']['google']['client_email'] = ''
# default['cwb-server']['providers']['google']['json_key_FILE'] = ''

### Base utilities
normal['build-essential']['compile_time'] = true
normal['apt']['compile_time_update'] = true
