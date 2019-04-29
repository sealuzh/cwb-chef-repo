all: status

status:
	sudo systemctl status nginx

# https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs
logs:
	journalctl -u ide.service

live_logs:
	journalctl -f -u ide.service

start:
	sudo systemctl start nginx

stop:
	sudo systemctl stop nginx
