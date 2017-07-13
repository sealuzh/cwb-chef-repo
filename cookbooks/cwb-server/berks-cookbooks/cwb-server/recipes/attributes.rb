require 'securerandom'

### Base utilities
node.normal['build-essential']['compile_time'] = true
node.normal['apt']['compile_time_update'] = true

### App
# Unless given, randomly generate a password for the database
node.normal_unless['cwb-server']['db']['password'] = SecureRandom.hex(24)
# Unless given, randomly generate secret key base (used for checking the integrity of signed cookies)
node.normal_unless['cwb-server']['env']['SECRET_KEY_BASE'] = SecureRandom.hex(64)

## Nginx
node.normal_unless['cwb-server']['nginx']['hostname'] = '0.0.0.0'

def detect_public_ip
  cmd = Mixlib::ShellOut.new(node['cwb-server']['host_detection'])
  cmd.run_command
  cmd.stdout.strip
rescue
  default_ip = (node['ipaddress'].empty? ? '33.33.33.20' : node['ipaddress'])
  Chef::Log.warn("Could not detect public IP with `#{node['cwb-server']['host_detection']}`
                  Using default IP #{default_ip}.")
  default_ip
end

given = node['cwb-server']['env']['CWB_SERVER_HOST']
if given.nil? || given.empty?
  cwb_server_host = detect_public_ip
  Chef::Log.info("Detected public IP #{cwb_server_host}")
  node.normal['cwb-server']['env']['CWB_SERVER_HOST'] = cwb_server_host
end

### Vagrant: https://supermarket.chef.io/cookbooks/vagrant#readme
node.default['vagrant']['version'] = '1.8.1'
node.default['vagrant']['user'] = node['cwb-server']['app']['user']
node.default['vagrant']['plugins'] = [
  # Ensure that Chef is installed within a VM
  { 'name' => 'vagrant-omnibus', 'version' =>  '1.4.1' },
  # Delete Chef client and node when destroying a VM
  { 'name' => 'vagrant-butcher', 'version' =>  '2.2.0' }
]  + node['cwb-server']['vagrant']['providers']
