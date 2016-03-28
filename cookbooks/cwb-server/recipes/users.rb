app = node['cwb-server']['app']

user app['user'] do
  action :create
  comment 'Runs the app'
  supports manage_home: true
  home "/home/#{app['user']}"
end

user app['deploy_user'] do
  action :create
  comment 'Deploys the app'
  supports manage_home: true
  home "/home/#{app['deploy_user']}"
end

group app['user'] do
  action :modify
  members [
    app['user'],
    app['deploy_user']
  ]
end

node.default['authorization']['sudo']['groups'] = [
  'sudo',
  node['current_user'],
  app['deploy_user']
]
node.default['authorization']['sudo']['passwordless'] = true
include_recipe 'sudo'
