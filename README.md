# cwb-chef-repo

This Chef repo provides cookbooks to automatically install and configure
[Cloud WorkBench](https://github.com/sealuzh/cloud-workbench).

## Requirements

> Interested in your own Cloud WorkBench installation?<br>
> Feel free to contact us: philipp.leitner[AT]chalmers.se or scheuner[AT]chalmers.se

* [Git](http://git-scm.com/)
* [Vagrant (1.8.1)](https://www.vagrantup.com/downloads.html)
    * [vagrant-omnibus (1.4.1)](https://github.com/chef/vagrant-omnibus) for auto-installation via Chef
    * [vagrant-aws (0.7.0)](https://github.com/mitchellh/vagrant-aws) for deployment in the Amazon EC2 Cloud
      ([alternative providers](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers) are available)
    * Install Vagrant with the [official installer](https://www.vagrantup.com/downloads.html) or with [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) via `brew cask install vagrant`
    * Install Vagrant plugins via

        ```bash
        vagrant plugin install vagrant-omnibus vagrant-aws;
        ```

* [Amazon EC2](https://aws.amazon.com/ec2/) account. Alternative providers are available (see Vagrant plugins).
  We have also deployed a CWB instance to OpenStack.
    * Both VMs (chef-server + cwb-server) must have a public IP address
    * Make sure you have created a private SSH key called `cloud-benchmarking` to
      log into cloud VMs and uploaded the corresponding public key to the cloud provider.
    * Ensure that incoming and outgoing traffic is allowed for ssh (22), http (80), and https (433).
      In Amazon EC2, you create a [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html)
      called `cwb-web`.
      If you do not explicitly specify a security group in your benchmark, make sure the `default` security group allows incoming ssh (22).
* [ChefDK](https://downloads.chef.io/chef-dk/) for benchmark cookbook development.
    * Install via the [official installer](https://downloads.chef.io/chefdk)

## Installation

1. Checkout repository.

    ```bash
    git clone https://github.com/sealuzh/cwb-chef-repo;
    ```

2. Navigate into the appropriate install directory.

    ```bash
    cd install/aws          # Amazon EC2 Cloud
    cd install/virtualbox   # Virtualbox (only for local testing, unless you have public IPs)
    ```

3. Configure `Vagrantfile` and
   copy your private ssh key (for AWS) into `cloud-benchmarking.pem`.<br>
   Find the *aws* config under `config.vm.provider :aws` (e.g., instance type)
   Find the *cwb-server* config under `chef.json`

    ```
    # For Amazon EC2
    AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY'] || 'my_aws_access_key'
    AWS_SECRET_KEY = ENV['AWS_SECRET_KEY'] || 'my_aws_secret_key'
    ```

4. Start automated installation and configuration.

    > *WARNING*: This will acquire 2 VMs: one for the Chef Server and one for the CWB Server.
    > Make sure you stop/terminate the VMs after usage in order to avoid unnecessary expenses.

    ```bash
    vagrant up --provider=aws          # Amazon EC2 Cloud
    vagrant up                         # Virtualbox (default provider)
    ```

5. Once the Chef Server completed provisioning (may take 5-10 minutes) with<br>
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

9. Once the CWB Server completed provisioning (may take 10-30 minutes
   depending on the chosen instance), reprovision to successfully complete the
   configuration (may take 1-5 minutes).

    ```bash
    cd $HOME/git/cwb-chef-repo/install/aws/
    vagrant provision cwb-server
    ```

10. Browser to `http://my_public_ip_of_cwb_server` and login with the default password `demo`

    ```bash
    # Query cwb-server IP
    vagrant ssh cwb-server --command 'wget -qO- http://ipecho.net/plain; echo'
    ```

> *Next steps:*
> 1) Run a sample benchmark: https://github.com/sealuzh/cwb-benchmarks#execute-a-basic-cli-benchmark
> 2) Write your own benchmark: https://github.com/sealuzh/cwb-benchmarks


## Deployment

Simply reprovision the CWB Server:

```bash
cd $HOME/git/cwb-chef-repo/install/aws/
vagrant provision cwb-server
```

> *Capistrano:* The current configuration needs to be slightly updated
>               for the new installation procedure.

## Manage VMs

Acquire 2 VMs and install `cwb-server` and `chef-server`.

```bash
vagrant up --provider=aws
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

This might be required after restarting an instance.

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

Precondition: SSH'ed into the *cwb-server* instance

### Installation directories

```bash
cd  /var/www/cloud-workbench
ls -l /etc/init/cloud-workbench*
cat /etc/nginx/sites-available/cloud-workbench
```

### Upstart

#### Targets

```bash
cloud-workbench-web
cloud-workbench-web-1
cloud-workbench
cloud-workbench-job
cloud-workbench-job-1
cloud-workbench-job-2
```

#### Status

```bash
sudo service cloud-workbench-job status
sudo initctl status cloud-workbench
sudo initctl status cloud-workbench-web
sudo initctl status cloud-workbench-job
```

#### Stop, Start, Restart

```bash
sudo service cloud-workbench-job stop
sudo initctl stop cloud-workbench-job

sudo service cloud-workbench-job start
sudo initctl start cloud-workbench-job

sudo service cloud-workbench-job restart
sudo initctl restart cloud-workbench-job
```

For further detail see: http://upstart.ubuntu.com/cookbook/

### View Logs

Precondition: SSH'ed into the target instance

#### Cloud WorkBench

```bash
sudo tail -f /var/log/upstart/cloud-workbench-web-*.log
sudo tail -f /var/log/upstart/cloud-workbench-job-*.log
```

#### Nginx

```bash
tail -f /var/log/nginx/cloud-workbench-access.log
tail -f /var/log/nginx/cloud-workbench-error.log
```
