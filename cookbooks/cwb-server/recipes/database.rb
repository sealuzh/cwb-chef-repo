include_recipe 'postgresql::client'
include_recipe 'postgresql::server'
# Make postgres_* resources available
include_recipe 'database::postgresql'

db = node['cwb-server']['db']
postgresql_connection_info = {
  host: node['postgresql']['config']['listen_addresses'],
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

postgresql_database db['name'] do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user db['user'] do
  connection postgresql_connection_info
  password db['password']
  database_name db['name']
  action [:create, :grant]
end

sql = "ALTER USER #{db['user']} WITH PASSWORD '#{db['password']}'"
execute 'update db user password' do
  command "sudo -u postgres psql -c \"#{sql}\""
end
