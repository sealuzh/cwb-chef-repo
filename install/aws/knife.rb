# Docs: https://docs.chef.io/config_rb_knife.html

# 1. Write the Chef server IP to file `chef_server_ip.env`
# 2. Update CWB_CHEF_REPO, CWB_BENCHMARKS, and ENVIRONMENT
# 3. Symlink this file to ~/.chef/knife.rb with:
#    `ln -s "$(pwd -P)/knife.rb" $HOME/.chef/knife.rb;`

CWB_CHEF_REPO  = ENV['HOME'] + '/Projects/cwb-chef-repo'
CWB_BENCHMARKS = ENV['HOME'] + '/Projects/cwb-benchmarks'
ENVIRONMENT = 'aws' # name of the install directory

##########################################################

SECRETS_DIR    = "#{CWB_CHEF_REPO}/install/#{ENVIRONMENT}"
chef_server_ip_file = "#{SECRETS_DIR}/chef_server_ip.env"
# MUST match with what is configured as api_fqdn on the chef-server (either IP or FQDN)
CHEF_SERVER_IP = ENV['CHEF_SERVER_IP'] || File.read(chef_server_ip_file).strip

log_level                :info
log_location             STDOUT
node_name                'cwb-server'
client_key               "#{SECRETS_DIR}/cwb-server.pem"
validation_client_name   'chef-validator'
validation_key           "#{SECRETS_DIR}/chef-validator.pem"
chef_server_url          "https://#{CHEF_SERVER_IP}:443/organizations/chef"
syntax_check_cache_path  ENV['HOME'] + '/.chef/syntax_check_cache'
cookbook_path            [CWB_BENCHMARKS]
ssl_verify_mode          :verify_none # or load certificate `knife ssl fetch`
