# cwb-chef-repo

This Chef repo provides cookbooks to automatically install and setup [Cloud WorkBench](https://github.com/sealuzh/cloud-workbench).

## Installation Requirements

**NOTICE**: Interested in your own Cloud WorkBench installation? Feel free to contact us (leitner[AT]ifi.uzh.ch or joel.scheuner[AT]uzh.ch). We still need to improve installation, documentation etc., but the tool itself is already quite useful.

* [Git](http://git-scm.com/)
* [Vagrant (1.6.5)](https://www.vagrantup.com/downloads)
    * [vagrant-omnibus (1.4.1)](https://github.com/schisamo/vagrant-omnibus)
    * [vagrant-aws (0.5.0)](https://github.com/mitchellh/vagrant-aws) for deployment in the Amazon EC2 Cloud
* Ruby (2.1.1) for development and deployment with Bundler
    * [Installation](https://www.ruby-lang.org/en/downloads/)
    * [Mac installation tutorial](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
    * [Windows installer](http://rubyinstaller.org/)
* [Amazon EC2](http://aws.amazon.com/en/ec2/) or Openstack cloud account. CWB can be automatically installed on two VMs that must have a public IP address.
    * Make sure you have created a private SSH key to log into cloud VM instances and uploaded the corresponding public key to the cloud provider.
    * Ensure that incoming and outgoing traffic is allowed for ssh (20), http (80), and https (433). In Amazon EC2, you can create a [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) `cwb-web`.


1. Vagrant can be easily installed with the installer for your system from [https://www.vagrantup.com/downloads](https://www.vagrantup.com/downloads)
2. The Vagrant plugins can be installed with this one-liner (for Openstack, use ``vagrant plugin install vagrant-openstack-plugin`` instead):

```bash
vagrant plugin install vagrant-omnibus; vagrant plugin install vagrant-aws;
```


## Initial Installation and Configuration
1. Checkout repository and install the toolchain dependencies for administration tasks (may take approximately 10-20 minutes).

    ```bash
    git clone https://github.com/sealuzh/cloud-workbench; cd cloud-workbench; bundle install --gemfile=Gemfile.tools --binstubs;
    # Check knife installation
    knife help
    ```

2. Navigate into the appropriate install directory.

    ```bash
    cd install/aws          # Amazon EC2 Cloud
    cd install/openstack    # Openstack Cloud
    cd install/virtualbox   # Virtualbox (only for development/testing because public IP configuration is not supported yet)
    ```

3. Complete the configurations in `Vagrantfile` and `config.yml.secret`.

    ```bash
    vim Vagrantfile
    vim config.yml.secret
    ```

4. Start automated installation and configuration.
WARNING: This will acquire 2 VMs your configured cloud: one for the Chef Server and one for the CWB Server. Make sure you terminate the VMs after usage in order to avoid unnecessary expenses.

    ```bash
    vagrant up --provider=aws          # Amazon EC2 Cloud
    vagrant up --provider=openstack    # Openstack Cloud
    vagrant up                         # Virtualbox (default provider)
    ```

5. Update the CHEF_SERVER_IP in `config.yml.secret` by filling in the public IP address assigned by your cloud provider (e.g. find out via the Amazon web interface).

    ```bash
    vim config.yml.secret
    ```

6. Once the Chef Server completed provisioning (may take 5-10 minutes) with `INFO: Report handlers complete`, setup the Chef Server authentication:
    1. Go to `https://CHEF_SERVER_IP` and accept the self-signed certificate [(or configure the Chef server appropriately)](https://docs.getchef.com/server_security.html)
    2. Login with the default username (`admin`) and password (`p@ssw0rd1`). You might want to change the default password immediately.
    3. Go to `https://CHEF_SERVER_IP/clients/new` and create a new client with the name `cwb-server` and enabled admin flag.
    4. Copy the generated private key and paste it into `chef_client_key.pem`
    5. Restrict file permissions with:

        ```bash
        chmod 600 chef_client_key.pem
        ```

    6. Go to `https://CHEF_SERVER_IP/clients/chef-validator/edit`, enable "Private Key", and click "Save Client"
    7. Copy this private key and paste it into `chef_validator.pem`
7. Configure Chef `knife` and Berkshelf `berks` tools
    1. Update `CHEF_SERVER` and `REPO_ROOT` within `knife.rb`

        ```bash
        vim knife.rb
        ```

    2. Move `knife.rb` to `$HOME/.chef/knife.rb` and `config.json` to `$HOME/.berkshelf/config.json`

        ```bash
        mkdir $HOME/.chef; mv knife.rb $HOME/.chef/knife.rb;
        mkdir $HOME/.berkshelf; mv config.json $HOME/.berkshelf/config.json;
        ```

8. Upload cookbooks to the Chef Server (alternatively with knife cookbook upload)

    ```bash
    cd ../../site-cookbooks/sysbench; berks install; berks upload;
    ```

9. Once the CWB Server completed provisioning (may take 30-50 minutes depending on the chosen instance!), reprovision once to successfully complete the configuration (may take 2-10 minutes).

    ```bash
    d ../../../install/aws/
    vagrant provision cwb_server
    ```

10. Deploy Rails application (see below)


## Deployment

Requires a Ruby on Rails development environment and checkout of the project. Make sure you completed step 1 of the section `Initial Installation and Configuration`.

### Initial configuration
1. Update the IP address of the cwb-server in `production.rb` (automatically configures the default password `demo`)

    ```bash
    cd $HOME/git/cloud-workbench            # Navigate to $REPO_ROOT
    cp config/deploy/production.example.rb config/deploy/production.rb
    vim config/deploy/production.rb
    ```

2. Check your settings with:

    ```bash
    bin/cap production deploy:check
    ```


### Deploy

Simply deploy new releases with: (may take 20 minutes for the first time).
You have to be in the $REPO_ROOT directory.

```bash
bin/cap production deploy
```

NOTE: This will restart the background job workers and should fail if there are currently running jobs.
Worker restarts can be avoided by setting a variable in the deploy config `set(:live, true)` or passing it with `bin/cap production deploy live=true`.
This is especially useful for GUI only updates

NOTE: Active schedules will be temporarily (for a very short time) disabled during deployment.


## Manage VMs
Further documentation of the Vagrant CLI: https://docs.vagrantup.com/v2/cli/index.html

Bring up VMs: Starts or acquires 2 VMs and installs `cwb_server` and `chef_server`. Alternative providers are `openstack` or `virtualbox` (default).

```bash
vagrant up --provider=aws
vagrant up cwb_server --provider=aws
vagrant up chef_server --provider=aws
```

SSH into a VM (default: cwb_server)

```bash
vagrant ssh
vagrant ssh chef_server
```

Provision VMs (default: both)

```bash
vagrant provision
vagrant provision cwb_server
vagrant provision chef_server
```

Halt VMs (default: both)

```bash
vagrant halt
vagrant halt cwb_server
vagrant halt chef_server

```

Destroy VMs (default: both)

```bash
vagrant destroy
vagrant destroy cwb_server
vagrant destroy chef_server
```


## Reconfiguration on IP Address Change

### Chef Server

* CWB Server configuration
    1. `cd ${REPO_ROOT}/install/${YOUR_PROVIDER}`
    2. `vim config.yml.secret`
    3. Update the Chef Server IP
    4. `vagrant provision cwb_server` to apply the changes (make sure you have set the `APPLY_SECRET_CONFIG` flag to true in the Vagrantfile)
* Workstation knife.rb
    1. `vim $HOME/.chef/knife.rb`
    2. Update the IP address of the Chef Server here

For more information about the Chef Server see:  https://docs.chef.io/chef/manage_server_open_source.html

### CWB Server

* Capistrano deployment config (only for deployment)
    1. `vim $REPO_ROOT/config/deploy/production.rb`
    2. Enter the IP address of the CWB Server here


## Manage CWB Server

Capistrano tasks can be used to easily conduct management tasks from the workstation on the CWB Server.

### Configuration

* Ensure you are in the root directory `cd REPO_ROOT`
* Ensure that the IP address of the CWB Server is configured in `REPO_ROOT/config/deploy/production.rb`

### Tasks

Print a list of all tasks including their description with `cap -T`

Always use the `bin/` prefix and include the environment e.g. `bin/cap production TASK_NAME`

#### Custom

* `cap production user:change[password]` Change the password for the default user: 'cap production user:change[new_password]'
* `cap production rake[command]` Invoke a rake command on the remote app server: 'cap production rake[about]'
* `cap production cron:clean` Clean system crontab
* `cap production cron:update` Reflect the Cron schedules from database in system cron
* `cap production worker:status_all` status_all delayed_job workers
* `cap production worker:restart_all` restart_all delayed_job workers
* `cap production worker:down_all` down_all delayed_job workers
* `cap production worker:up_all` up_all delayed_job workers

#### Default

* `cap production deploy` Deploy a new release
* `cap production deploy:check` Check if required files and directories exist for deployment
* `cap production deploy:start` Start application, workers, and scheduler
* `cap production deploy:stop` Stop scheduler, workers, and application
