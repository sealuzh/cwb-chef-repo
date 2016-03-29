require 'securerandom'

### Base utilities
node.set['build-essential']['compile_time'] = true
node.set['apt']['compile_time_update'] = true

### App
# Unless given, randomly generate a password for the database
node.set_unless['cwb-server']['db']['password'] = SecureRandom.hex(24)
# Unless given, randomly generate secret key base (used for checking the integrity of signed cookies)
node.set_unless['cwb-server']['env']['SECRET_KEY_BASE'] = SecureRandom.hex(64)

## Nginx
# TODO: Think about auto-detect IP/hostname here?!
# TODO: Set `CWB_SERVER_HOST` env
node.set_unless['cwb-server']['nginx']['hostname'] = '0.0.0.0'

# Use larger bucket size as the default 64 bit may not work with long hostnames (e.g. aws domain names)
# node.default['nginx']['server_names_hash_bucket_size'] = 128

### Vagrant: https://supermarket.chef.io/cookbooks/vagrant#readme
node.default['vagrant']['version'] = '1.8.1'
node.default['vagrant']['user'] = node['cwb-server']['app']['user']
node.default['vagrant']['plugins'] = [
  # Ensure that Chef is installed within a VM
  { 'name' => 'vagrant-omnibus', 'version' =>  '1.4.1' },
  # Delete Chef client and node when destroying a VM
  { 'name' => 'vagrant-butcher', 'version' =>  '2.2.0' }
]  + node['cwb-server']['vagrant']['providers']
