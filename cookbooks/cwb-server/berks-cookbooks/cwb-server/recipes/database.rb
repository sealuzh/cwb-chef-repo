db = node['cwb-server']['db']
# Known issue: https://github.com/sous-chefs/postgresql
# See: https://github.com/sous-chefs/postgresql/issues/555
target_locale = node['cwb-server']['system']['locale']

# Docs: https://github.com/sous-chefs/postgresql
postgresql_server_install 'Install PostgreSQL' do
  initdb_locale target_locale
  version db['postgresql_version']
  action :install
end

postgresql_server_install 'Setup my PostgreSQL server' do
  initdb_locale target_locale
  password db['postgres_password']
  port db['port']
  action :create
end

postgresql_user db['user'] do
  password db['password']
  createdb true
end

postgresql_database db['name'] do
  locale target_locale
  owner db['user']
end
