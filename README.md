# cwb-chef-repo

This Chef repo provides cookbooks to automatically install and configure
[Cloud WorkBench](https://github.com/sealuzh/cloud-workbench).

## Installation Requirements

> Interested in your own Cloud WorkBench installation?<br>
> Feel free to contact us: leitner[AT]ifi.uzh.ch or joel.scheuner[AT]uzh.ch

* [Git](http://git-scm.com/)
* [Vagrant (1.8.1)](https://www.vagrantup.com/downloads.html)
    * [vagrant-omnibus (1.4.1)](https://github.com/chef/vagrant-omnibus) for auto-installation via Chef
    * [vagrant-aws (0.7.0)](https://github.com/mitchellh/vagrant-aws) for deployment in the Amazon EC2 Cloud
      ([alternative providers](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers) are available)
* [Amazon EC2](https://aws.amazon.com/ec2/) account. Alternative providers are available (see above).
  We have also deployed a CWB instance to OpenStack.
    * Both VMs (chef-server + cwb-server) must have a public IP address
    * Make sure you have created a private SSH key to log into cloud VM instances and uploaded the corresponding public key to the cloud provider.
    * Ensure that incoming and outgoing traffic is allowed for ssh (20), http (80), and https (433).
      In Amazon EC2, you create a [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html)
      called `cwb-web`.

1. Vagrant can be installed with the installer for your system from [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
2. The Vagrant plugins can be installed with this one-liner:

    ```bash
    vagrant plugin install vagrant-omnibus vagrant-aws;
    ```

## Initial Installation and Configuration
1. Checkout repository.

    ```bash
    git clone https://github.com/sealuzh/cwb-chef-repo;
    ```

2. Navigate into the appropriate install directory.

    ```bash
    cd install/aws          # Amazon EC2 Cloud
    cd install/virtualbox   # Virtualbox (only for local testing, unless you have public IPs)
    ```

3. Complete the configurations in `Vagrantfile`.

    ```bash
    vim Vagrantfile
    ```

4. Start automated installation and configuration.

    > *WARNING*: This will acquire 2 VMs: one for the Chef Server and one for the CWB Server.
    > Make sure you stop/terminate the VMs after usage in order to avoid unnecessary expenses.

    ```bash
    vagrant up --provider=aws          # Amazon EC2 Cloud
    vagrant up                         # Virtualbox (default provider)
    ```

5. Update your *Vagrantfile* with the public IP addressed assigned by the cloud provider
   (e.g. look them up in your [AWS Console](https://aws.amazon.com/console/)).

    ```
    CHEF_SERVER_IP=my_public_ip_for_chef_server
    CWB_SERVER_IP=my_public_ip_for_cwb_server
    ```

6. Once the Chef Server completed provisioning (may take 5-10 minutes) with
   `INFO: Report handlers complete`, setup the Chef Server authentication:
    1. Go to `https://CHEF_SERVER_IP` and accept the self-signed certificate (or [configure](https://docs.chef.io/server_security.html) the Chef server appropriately)
    2. Login with the default username (`admin`) and password (`p@ssw0rd1`).
       You may want to change the default password immediately.
    3. Go to `https://CHEF_SERVER_IP/clients/new`, create a new client with the name `cwb-server` and enabled admin flag.
    4. Copy the generated private key and paste it into `cwb-server.pem`
    5. Restrict file permissions with:

        ```bash
        chmod 600 cwb-server.pem
        ```

    6. Go to `https://CHEF_SERVER_IP/clients/chef-validator/edit`, enable *Private Key*, and click *Save Client*
    7. Copy this private key and paste it into `chef-validator.pem`
7. Configure Chef `knife` and Berkshelf `berks` tools
    1. Within `knife.rb`, update CHEF_SERVER_HOST, CWB_BENCHMARKS, CWB_CHEF_REPO, and ENVIRONMENT.

        ```bash
        vim knife.rb
        ```

    2. Symlink (or copy/move) `knife.rb` to `$HOME/.chef/knife.rb` and `config.json` to `$HOME/.berkshelf/config.json`

        ```bash
        mkdir $HOME/.chef; ln -s knife.rb $HOME/.chef/knife.rb;
        mkdir $HOME/.berkshelf; ln -s config.json $HOME/.berkshelf/config.json;
        ```

8. Upload basic benchmark to the Chef Server

    ```bash
    cd $HOME/git;
    git clone https://github.com/sealuzh/cwb-benchmarks && cd cwb-benchmarks/cli-benchmark;
    berks install; berks upload;
    ```

9. Once the CWB Server completed provisioning (may take 20-40 minutes
   depending on the chosen instance), reprovision to successfully complete the
   configuration (may take 2-5 minutes).

    ```bash
    cd $HOME/git/cwb-chef-repo/install/aws/
    vagrant provision cwb-server
    ```

10. Browser to `http://my_public_ip_of_cwb_server` and login with the default password `demo`

> *Next steps:*
> 1) Create and run a sample benchmark
> 2) Write your own benchmark: https://github.com/sealuzh/cwb-benchmarks


## Deployment

Simply reprovision the CWB Server:

```bash
cd $HOME/git/cwb-chef-repo/install/aws/
vagrant provision cwb-server
```

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

### Chef Server

* CWB Server configuration in *Vagrantfile*
    1. `vim $HOME/git/cwb-chef-repo/install/aws/Vagrantfile`
    2. Update *CHEF_SERVER_IP*
    3. `vagrant provision cwb-server` to apply the changes
       (make sure you have not disabled *apply_secret_config* with false)
* Workstation *knife.rb*
    1. `vim $HOME/.chef/knife.rb`
    2. Update *CHEF_SERVER_IP*
