# Usage:
# Set as environment variable: export CHEF_PASSWORD=my_chef_password
# Set as make variable: make target CHEF_PASSWORD=my_chef_password
CHEF_USER?=cwb-server
CHEF_ORG?=chef
CHEF_EMAIL?=cwb@server.com
# MUST be >= 6 characters
CHEF_PASSWORD?=chefadmin

CWB_IP_FILE?=cwb_server_ip.env
CHEF_IP_FILE?=chef_server_ip.env

# Specify the backup to download/upload (default latest)
# * All: make backup CWB_BACKUP='*_cloud_workbench_production.*'
# * Specific match: make backup CWB_BACKUP='2019-01-07-1644*_cloud_workbench_production.*'
CWB_BACKUP?=
# Convert CWB_BACKUP match to shell multi-file syntax {file1,file2} or {} if no match could be found
CWB_BACKUP_FILES:={$(shell bak=$(CWB_BACKUP) && [ ! -z "$${bak}" ] && (find $(CWB_BACKUP) | sort | head -3 | xargs basename -- '.dump' '.sql' '.dir' '.tar' '.tar.gz' | tail -2 | paste -sd "," -) || echo '')}

all: status

### High-level targets

status:
	vagrant status

login: login_cwb

# Setup and configure CWB initially
setup: run setup_chef config_cwb print_cwb_ip

logs: cwb_logs

start: run

# Re-start an already setup CWB instance
run: vagrant_up config_cwb print_cwb_ip

# Re-configuration on IP address change
config_cwb: query_chef_ip provision_cwb

deploy: provision_cwb

stop:
	vagrant halt

# Creates and downloads a backup into ./backups
# NOTE: This temporarily stops the server (while creating the backup!)
backup: cwb_stop cwb_backup cwb_start download_backup

# Check logs for errors! via: make logs
# DANGER: This will erase the current data and restore a previous dump!!!
restore: upload_backup cwb_move_backup cwb_stop cwb_restore cwb_start

# DANGER: This will destroy both instances!!!
clean:
	vagrant destroy

### Vagrant

vagrant_up:
	vagrant up

login_cwb:
	vagrant ssh

login_chef:
	vagrant ssh chef-server

provision_chef:
	vagrant provision chef-server

provision_cwb:
	vagrant provision cwb-server

query_chef_ip:
	vagrant ssh chef-server --command 'wget -qO- http://ipecho.net/plain; echo' | tee $(CHEF_IP_FILE)

query_cwb_ip:
	vagrant ssh cwb-server --command 'wget -qO- http://ipecho.net/plain; echo' | tee $(CWB_IP_FILE)

print_chef_ip: query_chef_ip
	cat $(CHEF_IP_FILE)

print_cwb_ip: query_cwb_ip
	cat $(CWB_IP_FILE)

open_chef: query_chef_ip
	open "https://$(shell cat $(CHEF_IP_FILE))"

open_cwb: query_cwb_ip
	open "http://$(shell cat $(CWB_IP_FILE))"

### chef-server

setup_chef: query_chef_ip
	vagrant ssh chef-server --command 'sudo chef-server-ctl user-create $(CHEF_USER) CWB Server $(CHEF_EMAIL) $(CHEF_PASSWORD)' | tee cwb-server.pem && \
	vagrant ssh chef-server --command 'sudo chef-server-ctl org-create $(CHEF_ORG) "CWB Chef" --association $(CHEF_USER)' | tee chef-validator.pem && \
	chmod 600 cwb-server.pem

destroy_chef:
	vagrant ssh chef-server --command 'sudo chef-server-ctl org-delete $(CHEF_ORG) --yes'
	vagrant ssh chef-server --command 'sudo chef-server-ctl user-delete $(CHEF_USER) --yes'

### cwb-server

cwb_console:
	vagrant ssh cwb-server --command "sudo su - apps -c 'cd /var/www/cloud-workbench/current && RAILS_ENV=production bin/rails console'"

cwb_logs:
	vagrant ssh cwb-server --command 'sudo journalctl -u cloud-workbench* -f'

cwb_status:
	vagrant ssh cwb-server --command 'sudo systemctl status cloud-workbench.target'

cwb_start:
	vagrant ssh cwb-server --command 'sudo systemctl start cloud-workbench.target'

cwb_stop:
	vagrant ssh cwb-server --command 'sudo systemctl stop cloud-workbench.target'

cwb_restart:
	vagrant ssh cwb-server --command 'sudo systemctl restart cloud-workbench.target'

sync_cookbooks:
	vagrant rsync

ssh_config:
	vagrant ssh-config cwb-server > ssh_config

### cwb-server - BACKUP

# Highly recommended to `cwb_stop` before!
cwb_backup:
	vagrant ssh cwb-server --command 'sudo su - apps -c "cd /var/www/cloud-workbench/current && RAILS_ENV=production bin/rake data:backup"'

download_backup: ssh_config
	$(eval LATEST_BACKUP:="{$(shell vagrant ssh cwb-server --command 'cd /var/www/cloud-workbench/current/db/backups/ && find * | sort | head -3 | tail -2 | paste -sd "," -')}")
	mkdir -p ./backups
	# Download CWB_BACKUP if specified or the latest one by default
	bak=$(CWB_BACKUP) && scp -F ssh_config cwb-server:/var/www/cloud-workbench/shared/backups/$${bak:-$(LATEST_BACKUP)} ./backups

### cwb-server - RESTORE

upload_backup: ssh_config
	bak=$(CWB_BACKUP) && [ ! -z "$${bak}" ] || (echo "Variable CWB_BACKUP undefined!"; exit 1)
	scp -F ssh_config $(CWB_BACKUP) cwb-server:/home/ubuntu

cwb_move_backup:
	vagrant ssh cwb-server --command "sudo mv /home/ubuntu/$(CWB_BACKUP_FILES) /var/www/cloud-workbench/shared/backups/ && sudo chown apps:apps /var/www/cloud-workbench/shared/backups/*"

cwb_restore:
	vagrant ssh cwb-server --command "sudo su - apps -c 'cd /var/www/cloud-workbench/current && RAILS_ENV=production bin/rake data:restore[$(CWB_BACKUP_FILES)]'"
