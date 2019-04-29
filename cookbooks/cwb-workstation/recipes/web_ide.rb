include_recipe 'cwb-workstation::nodejs'
include_recipe 'cwb-workstation::ruby_binary'

deploy_user = node['cwb-workstation']['deploy_user']
ide_dir = '/var/www/theia-ruby-extension'
directory ide_dir do
    owner deploy_user
    group deploy_user
    mode '0755'
    action :create
    recursive true
end

git ide_dir do
    repository node['cwb-workstation']['ide_repo']
    revision 'master'
    user deploy_user
    group deploy_user
    action :sync # does a hard reset discarding uncommitted changes !
end

execute 'install project' do
    cwd ide_dir
    command 'yarn'
    user deploy_user
    group deploy_user
    action :run
end

systemd_unit 'ide.service' do
    # content ''
    # action [:create, :enable]
    action :nothing
end

execute 'systemctl daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
end

template '/etc/systemd/system/ide.service' do
    source 'ide.service.erb'
    variables(
        path: node['cwb-workstation']['env']['PATH'],
        working_dir: File.join(ide_dir, 'browser-app'),
        project_dir: '/home/cwb/benchmarks'
    )
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
    notifies :restart, 'systemd_unit[ide.service]', :delayed
end

cookbook_file '/home/ubuntu/Makefile' do
    source 'Makefile'
    user 'ubuntu'
    group 'ubuntu'
    mode '0755'
    action :create
end
