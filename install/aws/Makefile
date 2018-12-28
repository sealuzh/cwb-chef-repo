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
	vagrant ssh chef-server --command 'sudo chef-server-ctl user-create cwb-server CWB Server cwb@server.com chefadmin' | tee cwb-server.pem
	vagrant ssh chef-server --command 'sudo chef-server-ctl org-create chef "CWB Chef" --association cwb-server' | tee chef-validator.pem
	chmod 600 cwb-server.pem

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
