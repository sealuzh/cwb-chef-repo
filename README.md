cwb-chef-repo [![Build Status](https://travis-ci.org/sealuzh/cwb-chef-repo.svg?branch=master)](https://travis-ci.org/sealuzh/cwb-chef-repo)
=========

This Chef repo provides cookbooks to automatically install and configure
[Cloud WorkBench](https://github.com/sealuzh/cloud-workbench).

## Requirements

> Interested in your own Cloud WorkBench (CWB) installation?<br>
> These 10 steps will setup and configure CWB on AWS for you in less than 30 minutes (tested 2020-04-21) and costs ~1$ daily using two `t3.small` instances.

* [Git](http://git-scm.com/)
* [Vagrant (2.2.4)](https://www.vagrantup.com/downloads.html)
  * [vagrant-omnibus (1.5.0)](https://github.com/chef/vagrant-omnibus) for auto-installation via Chef
  * [vagrant-aws (0.7.2)](https://github.com/mitchellh/vagrant-aws) for deployment in the Amazon EC2 Cloud
    ([alternative providers](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers) are available)
  * Install Vagrant with the [official installer](https://www.vagrantup.com/downloads.html) or with [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) via `brew cask install vagrant`
  * Install Vagrant plugins via

      ```bash
      vagrant plugin install vagrant-omnibus vagrant-aws;
      ```

* [Amazon EC2](https://aws.amazon.com/ec2/) account. Alternative providers are available (see [cwb-benchmarks#Providers](https://github.com/sealuzh/cwb-benchmarks#providers)).
  We have also deployed a CWB instance to OpenStack.
  * Both VMs (chef-server + cwb-server) must have a public IP address
  * Make sure you have created a private SSH key called `cloud-benchmarking` to
      log into cloud VMs and uploaded the corresponding public key to the cloud provider.
  * Ensure that incoming and outgoing traffic is allowed for ssh (22), http (80), and https (433).
      In Amazon EC2, you create a [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html)
      called `cwb-web`.
      If you do not explicitly specify a security group in your benchmark, make sure the `default` security group allows incoming ssh (22).
* [ChefDK (3.9.0)](https://downloads.chef.io/chef-dk/) for benchmark cookbook development.
  * Install via the [official installer](https://downloads.chef.io/chefdk)

## Installation

> NOTE: Checkout the Makefile which automates many of these steps if you are familiar with the configuration.

1. Checkout repository.

    ```bash
    git clone https://github.com/sealuzh/cwb-chef-repo;
    ```

2. Navigate into the appropriate install directory.

    ```bash
    cd install/aws          # Amazon EC2 Cloud (recommended)
    cd install/azure        # Microsoft Azure Cloud
    cd install/openstack    # OpenStack Cloud with public IP
    cd install/virtualbox   # Virtualbox (only for local development, unless you have public IPs)
    ```

3. Configure `Vagrantfile` and
   copy your private ssh key (for AWS) into `cloud-benchmarking.pem`.<br>

    ```bash
    # For Amazon EC2
    AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY'] || 'my_aws_access_key'
    AWS_SECRET_KEY = ENV['AWS_SECRET_KEY'] || 'my_aws_secret_key'
    # SSH Key
    SSH_KEY_PATH = ENV['SSH_KEY_PATH'] || 'cloud-benchmarking.pem'
    SSH_KEY_NAME = ENV['SSH_KEY_NAME'] || 'cloud-benchmarking'
    ```

   * The private key will be copied into the cwb-server (`/home/apps/.ssh/cloud-benchmarking.pem`) for provisioning cloud VMs.
   * Find the *aws* config under `config.vm.provider :aws` (e.g., instance type).
   * Find the *cwb-server* config under `chef.json`. See [providers](https://github.com/sealuzh/cwb-benchmarks/blob/master/docs/PROVIDERS.md) for details how to configure other cloud providers.

4. Start automated installation and configuration.

    > *WARNING*: This will acquire 2 VMs: one for the Chef Server and one for the CWB Server.
    > Make sure you stop/terminate the VMs after usage in order to avoid unnecessary expenses.

    ```bash
    vagrant up
    ```

5. Once the Chef Server completed provisioning (around 4' on a t2.small instance) with<br>
   `INFO: Report handlers complete`,<br>
   update the public IP of *chef-server* (assigned by your provider)
    * Automatic query

        ```bash
        vagrant ssh chef-server --command 'wget -qO- http://ipecho.net/plain; echo' | tee chef_server_ip.env
        ```

    * Manual lookup (e.g. in your [AWS Console](https://aws.amazon.com/console/)) and
      save it to the file *chef_server_ip.env*

6. Setup the Chef Server

    1. Create the *cwb-server* admin user (replace `chefadmin` with a password of your choice)

        ```bash
        vagrant ssh chef-server --command 'sudo chef-server-ctl user-create cwb-server CWB Server cwb@server.com chefadmin' | tee cwb-server.pem
        ```

    2. Create the *chef-validator* organization

        ```bash
        vagrant ssh chef-server --command 'sudo chef-server-ctl org-create chef "CWB Chef" --association cwb-server' | tee chef-validator.pem
        ```

    3. Restrict file permissions with

        ```bash
        chmod 600 cwb-server.pem
        ```

7. Configure Chef `knife` and Berkshelf `berks` tools
    1. Within `knife.rb`, update CWB_CHEF_REPO, CWB_BENCHMARKS, and ENVIRONMENT.

    2. Symlink `knife.rb` to `$HOME/.chef/knife.rb` and `config.json` to `$HOME/.berkshelf/config.json`

        ```bash
        mkdir -p $HOME/.chef; ln -s "$(pwd -P)/knife.rb" $HOME/.chef/knife.rb;
        mkdir -p $HOME/.berkshelf; ln -s "$(pwd -P)/config.json" $HOME/.berkshelf/config.json;
        ```

8. Upload basic benchmark to the Chef Server

    ```bash
    cd $HOME/git;
    git clone https://github.com/sealuzh/cwb-benchmarks && cd cwb-benchmarks/cli-benchmark;
    berks install && berks upload;
    ```

9. Once the CWB Server completed provisioning (around 9' on a t2.small instance), reprovision to successfully complete the
   configuration (around 1').

    ```bash
    cd $HOME/git/cwb-chef-repo/install/aws/
    vagrant provision cwb-server
    ```

10. Browser to `http://my_public_ip_of_cwb_server` (http://33.33.33.20 for virtualbox) and login with the default password `demo`

    ```bash
    # Query public cwb-server IP
    vagrant ssh cwb-server --command 'wget -qO- http://ipecho.net/plain; echo'
    ```

> *Next steps:*
> 1) Run a sample benchmark: https://github.com/sealuzh/cwb-benchmarks#execute-a-basic-cli-benchmark
> 2) Write your own benchmark: https://github.com/sealuzh/cwb-benchmarks

## Workstation

This option automatically configures configures the browser-based IDE [theia](https://github.com/theia-ide/theia) with the [theia-ruby-extension](https://github.com/theia-ide/theia-ruby-extension) for authoring CWB benchmark cookbooks.
Notice that authentication is NOT supported for this optional component.

1. Configure the desired number of editor instances via `NUM_WORKSTATIONS = 1` in the Vagrantfile
2. Setup everything via `vagrant up`
3. Access the web-editor via http://WORKSTATION_IP

## Deployment

```bash
make deploy
```

Automates reprovisioning of the cwb-server for triggering deployment:

```bash
cd $HOME/git/cwb-chef-repo/install/aws/
vagrant provision cwb-server
```

## Manage VMs

Acquire 2 VMs and install `cwb-server` and `chef-server`.

```bash
vagrant up
```

SSH into a VM (default: cwb-server)

```bash
vagrant ssh
vagrant ssh chef-server
```

Provision VMs

```bash
vagrant provision
vagrant provision cwb-server
vagrant provision chef-server
```

Sync folders (i.e., update cookbooks)

```bash
vagrant rsync
vagrant rsync cwb-server
vagrant rsync chef-server
```

Halt (i.e., stop) VMs

```bash
vagrant halt
vagrant halt cwb-server
vagrant halt chef-server
```

Destroy (i.e., terminate) VMs

```bash
vagrant destroy
vagrant destroy cwb-server
vagrant destroy chef-server
```

Refer to [Vagrant CLI](https://www.vagrantup.com/docs/cli/index.html) for further commands.

## Reconfiguration on IP Address Change

```bash
make config_cwb
```

This make target automates the following steps:

1. Update *chef-server* IP

    * Automatic query

        ```bash
        vagrant ssh chef-server --command 'wget -qO- http://ipecho.net/plain; echo' | tee chef_server_ip.env
        ```

    * Manual lookup (e.g. in your [AWS Console](https://aws.amazon.com/console/)) and
      save it to the file *chef_server_ip.env*


2. Apply changes to *cwb-server*

    ```bash
    vagrant provision cwb-server
    ```

## Manage Services

Precondition: SSH'ed into the *cwb-server* instance (if not using a make target locally)

### Systemd

[Foreman](http://ddollar.github.io/foreman/#SYSTEMD-EXPORT) creates Systemd service templates upon deployment under `/etc/systemd/system/`. Background on [How To Use Systemctl to Manage Systemd Services and Units](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)

#### Targets

```bash
nginx.service

cloud-workbench.target
cloud-workbench-web.target
cloud-workbench-web@3000.service
cloud-workbench-job.target
cloud-workbench-job@3100.service
cloud-workbench-job@3101.service
...
```

#### Status, Start, Stop, Restart

```bash
make cwb_status
make cwb_start
make cwb_stop
make cwb_restart
```

Automates the following `cloud-workbench.target` commands:

```bash
sudo systemctl status cloud-workbench.target
sudo systemctl start cloud-workbench.target
sudo systemctl stop cloud-workbench.target
sudo systemctl restart cloud-workbench.target
# Further examples
sudo systemctl stop cloud-workbench-job.target
sudo systemctl start cloud-workbench-job@3100.service
sudo systemctl restart cloud-workbench-web.target
```

For further detail see: https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units

### View Logs

Precondition: SSH'ed into the target instance

#### Cloud WorkBench

```bash
make logs
```

Automates attaching to the cwb-server logs:

```bash
# Real-time (make logs)
journalctl -u cloud-workbench* -f
# Recent
journalctl -u cloud-workbench* -n 20

journalctl -u cloud-workbench*
journalctl -u cloud-workbench-web*
journalctl -u cloud-workbench-job*
journalctl -u cloud-workbench-job@3100.service

tail -f /var/log/syslog
```

#### Benchmark Schedule Triggers

```bash
cat /var/www/cloud-workbench/shared/log/benchmark_schedule.log
```

#### Nginx

```bash
tail -f /var/log/nginx/cloud-workbench-access.log
tail -f /var/log/nginx/cloud-workbench-error.log
```

### Installation directories (cwb-server)

```bash
# Rails app
cd /var/www/cloud-workbench/current
# Storage directory (where materialized Vagrantfiles are stored)
cd /var/www/cloud-workbench/shared/storage/production
# NGING proxy (sudo nginx -s reload)
cat /etc/nginx/sites-available/cloud-workbench
# PostgreSQL database (sudo su postgres)
ls /var/lib/postgresql/9.6/main
# Systemd service
ls -l /etc/systemd/system/cloud-workbench*
```

### Rails Console

```bash
make cwb_console
```

Automates attaching to the cwb-server logs:

```bash
sudo su - apps
cd /var/www/cloud-workbench/current && RAILS_ENV=production bin/rails c
```

### Backup

```bash
make backup
```

Automates the following backup process:

```bash
# Login into cwb-server
vagrant ssh cwb-server
# Stop server
sudo systemctl stop cloud-workbench.target
# Backup on cwb-server
sudo su - apps
cd /var/www/cloud-workbench/current
bin/rake data:backup
bin/rake data:list
# Start server
exit
sudo systemctl start cloud-workbench.target

# Download from cwb-server
exit
vagrant ssh-config cwb-server > ssh_config
scp -F ssh_config cwb-server:/var/www/cloud-workbench/shared/backups/*_cloud_workbench_production.* .
```

### Restore

```bash
make restore CWB_BACKUP=backups/2019-01-07-18*cloud_workbench_production*
```

Automates the following restore process:

```bash
# Upload to cwb-server
vagrant ssh-config cwb-server > ssh_config
scp -F ssh_config *_cloud_workbench_production.* cwb-server:/home/ubuntu

# Login into cwb-server
vagrant ssh cwb-server
# Move files
sudo mv /home/ubuntu/*_cloud_workbench_production.* /var/www/cloud-workbench/shared/backups/ && sudo chown apps:apps /var/www/cloud-workbench/shared/backups/*
# Stop server
sudo systemctl stop cloud-workbench.target
# Restore from backup (purges current state!)
sudo su - apps
cd /var/www/cloud-workbench/current
bin/rake data:list # List backups
bin/rake data:restore[cloud_workbench_production] # File pattern argument or common date prefix (of .dump and .tar.gz)
# Start server
exit
sudo systemctl start cloud-workbench.target
# Check logs for errors
journalctl -u cloud-workbench* -f
```

### PostgreSQL

Save login credentials via a [password file](https://www.postgresql.org/docs/9.6/static/libpq-pgpass.html):

```bash
echo "localhost:5432:cloud_workbench_production:postgres:rootcloud" > ~/.pgpass
chmod 0600 ~/.pgpass
```
