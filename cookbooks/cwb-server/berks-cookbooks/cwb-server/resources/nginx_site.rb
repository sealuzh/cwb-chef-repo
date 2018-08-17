provides :nginx_site

property :name, String, name_property: true
property :conf_cookbook, String, default: 'cwb-server'
property :conf_template, String, default: 'nginx.vhost.conf.erb'
property :conf_variables, Hash, default: {}
property :site_available, String, default: lazy { "/etc/nginx/sites-available/#{name}" }
property :site_enabled, String, default: lazy { "/etc/nginx/sites-enabled/#{name}" }

default_action :enable

load_current_value do
  # Nothing to load
end

action :enable do
  # Pre-declare NGINX resource such that it can be notified
  service 'nginx'

  template new_resource.site_available do
    cookbook new_resource.conf_cookbook
    source new_resource.conf_template
    variables new_resource.conf_variables
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[nginx]'
  end

  link new_resource.site_enabled do
    to new_resource.site_available
    not_if "test -f #{new_resource.site_enabled}"
    notifies :restart, 'service[nginx]'
  end
end

action :disable do
  # Pre-declare NGINX resource such that it can be notified
  service 'nginx'

  link new_resource.site_enabled do
    action :delete
    only_if "test -f #{new_resource.site_enabled}"
    notifies :restart, 'service[nginx]'
  end
end
