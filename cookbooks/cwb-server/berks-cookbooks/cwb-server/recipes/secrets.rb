require 'base64'
require 'securerandom'

app_user = node['cwb-server']['app']['user']
app_user_home = "/home/#{app_user}"

def default_env(name, value)
  node.default['cwb-server']['env'][name] = value
end

def create_dir(path, user)
  directory path do
    owner user
    group user
    mode 00755
  end
end

def store_key(path, key, user)
  file path do
    content key
    backup false
    owner user
    group user
    mode '0600'
  end
end

# Use file `/home/apps/.secret_key_base` to cache generated `SECRET_KEY_BASE`
secret_key_base_path = "#{app_user_home}/.secret_key_base"
if node['cwb-server']['env']['SECRET_KEY_BASE'].nil?
  if File.exist?(secret_key_base_path)
    node.normal['cwb-server']['env']['SECRET_KEY_BASE'] = File.read(secret_key_base_path)
  else
    new_key = SecureRandom.hex(64)
    store_key secret_key_base_path, new_key, app_user
    node.normal['cwb-server']['env']['SECRET_KEY_BASE'] = new_key
  end
end

# Conventions
# KEY: the key itself (i.e., secret content)
# KEY_NAME: the name of the key
# KEY_PATH: the path where the key resides
dot_profile_path = "#{app_user_home}/.profile"
if node['cwb-server']['apply_secret_config']
  # SSH
  ssh = node['cwb-server']['ssh']
  ssh_dir = "#{app_user_home}/.ssh"
  key_path = "#{ssh_dir}/#{ssh['key_name']}.pem"
  create_dir ssh_dir, app_user
  store_key key_path, ssh['key'], app_user
  store_key "#{key_path}.pub", ssh['pub_key'], app_user
  default_env 'SSH_KEY_NAME', ssh['key_name']
  default_env 'SSH_KEY_PATH', key_path

  # Chef
  chef = node['cwb-server']['chef']
  chef_dir = "#{app_user_home}/.chef"
  create_dir chef_dir, app_user
  default_env 'CHEF_SERVER_URL', chef['server_url']
  default_env 'CHEF_NODE_NAME', chef['node_name']
  client_key_path = "#{chef_dir}/#{chef['client_key_name']}.pem"
  store_key client_key_path, chef['client_key'], app_user
  default_env 'CHEF_CLIENT_KEY_NAME', chef['client_key_name']
  default_env 'CHEF_CLIENT_KEY_PATH', client_key_path
  validation_key_path = "#{chef_dir}/#{chef['validation_key_name']}.pem"
  store_key validation_key_path, chef['validation_key'], app_user
  default_env 'CHEF_VALIDATION_KEY_NAME', chef['validation_key_name']
  default_env 'CHEF_VALIDATION_KEY_PATH', validation_key_path

  # Chef VM Provisioning
  default_env 'CHEF_OMNIBUS_CHEF_VERSION', chef['omnibus_chef_version']
  default_env 'CHEF_PROVISIONING_PATH', chef['provisioning_path']

  # Providers
  providers = node['cwb-server']['providers']
  providers_dir = "#{app_user_home}/providers"
  directory providers_dir do
    owner app_user
    group app_user
    mode 00755
  end

  BASE64_SUFFIX = '_BASE64'.freeze
  base64_filter = proc do |p, k, v, b|
    if k.include?(BASE64_SUFFIX)
      new_k = k.sub(BASE64_SUFFIX, '')
      new_v = Base64.decode64(v)
      [p, new_k, new_v, b]
    else
      [p, k, v, b]
    end
  end
  FILE_SUFFIX = '_FILE'.freeze
  file_filter = proc do |p, k, v, b|
    if k.include?(FILE_SUFFIX)
      clean_k = k.sub(FILE_SUFFIX, '')
      file_name = providers[p][clean_k + '_name'] || p
      new_k = clean_k + '_path'
      provider_dir = "#{providers_dir}/#{p}"
      file_path = "#{provider_dir}/#{file_name}.pem"
      # create_dir(provider_dir, app_user) in outer Chef context
      eval("create_dir('#{provider_dir}', '#{app_user}')", b)
      # store_key(file_path, v, app_user) in outer Chef context
      eval("store_key('#{file_path}', '#{v}', '#{app_user}')", b)
      [p, new_k, file_path, b]
    else
      [p, k, v, b]
    end
  end
  env_filter = proc do |p, k, v, b|
    new_k = (p + '_' + k).upcase
    eval("default_env('#{new_k}', '#{v}')", b)
    [p, new_k, v, b]
  end
  providers.each do |provider, attributes|
    attributes.each do |key, value|
      [provider, key, value, binding].instance_eval(&base64_filter)
                                     .instance_eval(&file_filter)
                                     .instance_eval(&env_filter)
    end
  end
  # Convenience for app user that wants to source the environment
  template dot_profile_path do
    source 'dot_profile.erb'
    backup false
    owner app_user
    group app_user
    mode 0600
    variables(env: node['cwb-server']['env'])
  end
else
  secret_dirs = %w(.chef .ssh providers)
  secret_dirs.each do |dir|
    directory dir do
      action :delete
    end
    file dot_profile_path do
      backup false
      action :delete
    end
  end
end
