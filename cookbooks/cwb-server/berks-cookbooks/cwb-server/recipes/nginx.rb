# Based on Launchpad distribution: https://www.nginx.com/resources/wiki/start/topics/tutorials/install/#
# Launchpad: https://launchpad.net/~nginx/+archive/ubuntu/development
# Maintains up-to date NGINX distributions with some additional compiled-in modules
package 'software-properties-common' do
  action :install
end

apt_repository 'nginx' do
  uri 'ppa:nginx/stable'
  distribution node['lsb']['codename']
end

package 'nginx' do
  action :install
end

service 'nginx' do
  action [:start, :enable]
end

# Disable default NGINX site
nginx_site 'default' do
  action :disable
end

nginx_site node['cwb-server']['app']['name'] do
  conf_template 'nginx.vhost.conf.erb'
  conf_variables({
    app: node['cwb-server']['app'],
    nginx: node['cwb-server']['nginx']
  })
  action :enable
end
