db = node['cwb-server']['db']

# Known issue: https://github.com/sous-chefs/postgresql/issues/555
# * Setting up a PostgreSQL DB fails due to incompatible locales
# Workaround: Explicitly set the locale and make sure `init_db_locale` (for the DB template)
#   matches `locale` used when creating a database
#   PLUS: make sure the target locale is also the system's default locale
target_locale = node['cwb-server']['system']['locale']

# Docs: https://github.com/sous-chefs/postgresql
postgresql_server_install 'Install and setup PostgreSQL' do
  initdb_locale target_locale
  version db['postgresql_version']
  password db['postgres_password']
  port db['port']
  action [:install, :create]
end

postgresql_user db['user'] do
  password db['password']
  createdb true
end

postgresql_database db['name'] do
  locale target_locale
  owner db['user']
  port db['port']
end

# Using this to generate a service resource to control
find_resource(:service, 'postgresql') do
  extend PostgresqlCookbook::Helpers
  service_name lazy { platform_service_name }
  supports restart: true, status: true, reload: true
  action [:enable, :start]
end

postgresql_server_conf 'My PostgreSQL Config' do
  version db['postgresql_version']
  notifies :reload, 'service[postgresql]'
end
