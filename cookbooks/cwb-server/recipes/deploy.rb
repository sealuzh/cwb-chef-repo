app = node['cwb-server']['app']
env = node['cwb-server']['env']

# Required for compiling the pg gem
package 'libpq-dev'
# Required for compiling the nokogiri gem
package 'libgmp3-dev'
package 'zlib1g-dev'

directory app['dir'] do
  owner app['user']
  group app['user']
  mode '0755'
  recursive true
  action :create
end

# These variables MUST be evaluated outside of the deploy resource
# TODO: Replace with helper method
env_variables = env.map { |k, v| "#{k}=#{v}" }.join("\n")
# TODO: refactor into method `only_rails_env(env)`
common_groups = %w(development test staging production doc)
common_groups.delete(env['RAILS_ENV'])
# Bundler options: http://bundler.io/v1.11/deploying.html
# --deployment installs gems into `vendor/bundle` (encapsulate from system ruby)
bundle_install = "bin/bundle install --deployment --without #{common_groups.join(' ')}"

migration_cmd = 'bin/rake db:migrate --trace'
precompile_assets = 'bin/rake assets:precompile'
update_pw_cmd = "bin/rake user:create[seal@uzh.ch,#{app['user_password']}]"
# Example:
# sudo bin/foreman export systemd /etc/systemd/system \
#   --procfile Procfile_production --env .env --app cloud-workbench \
#   --formation web=1,job=1 --port 3000 --user app
foreman_opts = "--procfile Procfile_production \
                --env .env \
                --app #{app['name']} \
                --formation web=1,job=#{app['num_workers']} \
                --port #{app['port']} \
                --user #{app['user']}"
export_systemd_template = "sudo bin/foreman export systemd /etc/systemd/system #{foreman_opts}"
reload_systemd_cmd = 'sudo systemctl daemon-reload'
configure_systemd_cmd = "#{export_systemd_template} && #{reload_systemd_cmd}"
deploy app['name'] do
  deploy_to app['dir']
  scm_provider Chef::Provider::Git
  repo app['repo']
  branch app['branch']
  keep_releases 5
  rollback_on_error app['rollback_on_error']
  action :deploy

  ### User and group
  user app['deploy_user']
  group app['user']

  ### Migrations
  before_migrate do
    # TODO: Consider using a log management tool (e.g., logrotate)
    # SEE: https://github.com/heroku/rails_12factor
    # MUST remove existing log directory before creating the symlink
    directory File.join(release_path, 'log') do
      owner new_resource.user
      group new_resource.group
      recursive true
      action :delete
    end

    # Using different owners is useless because this resource enforces ownership
    # of the entire deployment directory recursively:
    # See https://github.com/chef/chef/blob/master/lib/chef/provider/deploy.rb#L277
    %w(log storage vendor/bundle public/assets).each do |dir|
      directory File.join(shared_path, dir) do
        owner new_resource.user
        group new_resource.group
        mode '0755'
        recursive true
        action :create
      end
      # MUST link the log dir before any Rails commands creates this directory!
      link File.join(release_path, dir) do
        to File.join(shared_path, dir)
        # mode '0755' # Not implemented!
      end
    end

    # Based on: https://github.com/poise/application_ruby/blob/v3.0.2/providers/rails.rb
    # Inspired by: https://github.com/capistrano/bundler
    # TODO: Check whether log statements are shown at the right time
    Chef::Log.info 'Running bundle install'
    execute bundle_install do
      cwd release_path
      user new_resource.user
      environment new_resource.environment
    end

    directory File.join(shared_path, 'config') do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      action :create
    end

    template File.join(shared_path, 'config', 'database.yml') do
      source 'database.yml.erb'
      owner new_resource.user
      group new_resource.group
      mode '0644'
      variables(db: node['cwb-server']['db'])
    end
  end
  symlink_before_migrate(
    'config/database.yml' => 'config/database.yml'
  )
  migrate true
  migration_command migration_cmd
  # TODO: refactor into `env_string_hash(envs)`
  # HOME must be set to deploy user for bundler
  environment(env.map { |k, v| [k.to_s, v.to_s] }.to_h.merge('HOME' => "/home/#{app['user']}"))

  ### Symlinks
  purge_before_symlink.clear
  create_dirs_before_symlink.clear
  before_symlink do
    file File.join(shared_path, '.env') do
      owner new_resource.user
      group new_resource.group
      mode '0644'
      content env_variables
    end

    Chef::Log.info('Precompiling assets')
    execute precompile_assets do
      cwd release_path
      user new_resource.user
      environment new_resource.environment
    end
  end
  # NOTE: `log` needs to be symlinked before any Rails commands writes to it (see before_migrate)
  # NOTE: Target directory is not created if non-existent
  symlinks(
    '.env' => '.env'
    # 'pids' => 'tmp/pids'
    # CWB old
    # 'tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage chef-repo'
    # CAPIstrano rails: https://github.com/capistrano/rails
    # 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'
  )

  ### Restart
  before_restart do
    execute 'update cwb user password' do
      command update_pw_cmd
      cwd release_path
      user new_resource.user
      environment new_resource.environment
    end

    ruby_block 'grant app user ownership' do
      block do
        FileUtils.chown_R(app['user'], app['user'], File.join(shared_path, 'storage'))
        FileUtils.chown_R(app['user'], app['user'], File.join(shared_path, 'log'))
        FileUtils.chown_R(app['user'], app['user'], File.join(shared_path, 'vendor'))
        # The app user needs to access cache files (e.g., `/var/www/cloud-workbench/releases/20180818085533/tmp/cache/bootsnap-compile-cache/...`)
        FileUtils.chown_R(app['user'], app['user'], File.join(release_path, 'tmp'))
      end
    end

    Chef::Log.info('Restarting cloud-workbench')
    # `release_path` is not available within the resources
    current_release = release_path
    execute 'configure-systemd' do
      command configure_systemd_cmd
      cwd current_release
      user new_resource.user
      environment new_resource.environment
    end
  end
  # ENHANCEMENT: Think about graceful restart for currently running worker processes!
  restart_command "sudo systemctl restart #{app['name']}.target"
end
