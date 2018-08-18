def detect_public_ip
  cmd = Mixlib::ShellOut.new(node['cwb-server']['host_detection'])
  cmd.run_command
  cmd.stdout.strip
rescue
  default_ip = node['ipaddress'] || '33.33.33.20'
  Chef::Log.warn("Could not detect public IP with `#{node['cwb-server']['host_detection']}`
                  Using default IP #{default_ip}.")
  default_ip
end

given = node['cwb-server']['env']['CWB_SERVER_HOST']
if given.nil? || given.empty?
  cwb_server_host = detect_public_ip
  Chef::Log.info("Detected public IP #{cwb_server_host}")
  node.normal['cwb-server']['env']['CWB_SERVER_HOST'] = cwb_server_host
end
