# Usage:
# Set as environment variable: export CHEF_PASSWORD=my_chef_password
# Set as make variable: make target CHEF_PASSWORD=my_chef_password
CHEF_USER?=cwb-server
CHEF_ORG?=chef
CHEF_EMAIL?=cwb@server.com
# MUST be >= 6 characters
CHEF_PASSWORD?=chefadmin

all: status

status:
	vagrant status

# Setup and configure CWB
setup: run setup_chef config_cwb print_cwb_ip

start: run

# Re-start an already setup CWB instance
run: vagrant_up config_cwb print_cwb_ip

vagrant_up:
	vagrant up

stop:
	vagrant halt

setup_chef: query_chef_ip
	vagrant ssh chef-server --command 'sudo chef-server-ctl user-create $(CHEF_USER) CWB Server $(CHEF_EMAIL) $(CHEF_PASSWORD)' | tee cwb-server.pem && \
	vagrant ssh chef-server --command 'sudo chef-server-ctl org-create $(CHEF_ORG) "CWB Chef" --association $(CHEF_USER)' | tee chef-validator.pem && \
	chmod 600 cwb-server.pem

destroy_chef:
	vagrant ssh chef-server --command 'sudo chef-server-ctl org-delete $(CHEF_ORG) --yes'
	vagrant ssh chef-server --command 'sudo chef-server-ctl user-delete $(CHEF_USER) --yes'

deploy:
	provision_cwb

provision_cwb:
	vagrant provision cwb-server

login_cwb:
	vagrant ssh

login_chef:
	vagrant ssh chef-server

config_cwb: query_chef_ip provision_cwb

sync_cookbooks:
	vagrant rsync

query_chef_ip:
	vagrant ssh chef-server --command 'wget -qO- http://ipecho.net/plain; echo' | tee chef_server_ip.env

print_cwb_ip:
	vagrant ssh cwb-server --command 'wget -qO- http://ipecho.net/plain; echo'

clean:
	vagrant destroy
