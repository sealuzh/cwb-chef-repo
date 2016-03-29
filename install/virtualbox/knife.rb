# Docs: https://docs.chef.io/config_rb_knife.html

# 1. Update CHEF_SERVER_HOST, CWB_BENCHMARKS, CWB_CHEF_REPO, and ENVIRONMENT
# 2. Copy this file to ~/.chef/knife.rb

# MUST match with what is configured as api_fqdn on the chef-server (either IP or FQDN)
CHEF_SERVER_IP = '33.33.33.10'
CWB_BENCHMARKS = '~/git/cwb-benchmarks'
CWB_CHEF_REPO  = '~/git/cwb-chef-repo'
# Install environment (name of the install directory)
ENVIRONMENT = 'virtualbox-development'

SECRETS_DIR    = "#{CWB_CHEF_REPO}/install/#{ENVIRONMENT}"

log_level                :info
log_location             STDOUT
node_name                'cwb-server'
client_key               "#{SECRETS_DIR}/cwb-server.pem"
validation_client_name   'chef-validator'
validation_key           "#{SECRETS_DIR}/chef-validator.pem"
chef_server_url          "https://#{CHEF_SERVER_IP}:443"
syntax_check_cache_path  '~/.chef/syntax_check_cache'
cookbook_path            [CWB_BENCHMARKS]
