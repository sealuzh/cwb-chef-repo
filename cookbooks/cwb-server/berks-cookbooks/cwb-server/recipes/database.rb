db = node['cwb-server']['db']

# Docs: https://github.com/sous-chefs/postgresql
postgresql_server_install 'Install PostgreSQL' do
  version db['version']
  action :install
end

postgresql_server_install 'Setup my PostgreSQL server' do
  password db['postgres_password']
  port db['port']
  action :create
end

postgresql_user db['user'] do
  password db['password']
  createdb true
end

postgresql_database db['name'] do
  owner db['user']
end
