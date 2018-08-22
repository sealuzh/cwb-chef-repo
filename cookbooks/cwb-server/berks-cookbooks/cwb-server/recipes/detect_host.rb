def guess_public_ip
  node.read('cloud', 'public_ipv4') || detect_public_ip || '33.33.33.20'
end

def detect_public_ip
  cmd = Mixlib::ShellOut.new(node['cwb-server']['host_detection'])
  cmd.run_command
  cmd.stdout.strip
rescue
  Chef::Log.warn("Could not detect public IP with `#{node['cwb-server']['host_detection']}`
                  Using default IP #{default_ip}.")
  nil
end

given = node['cwb-server']['env']['CWB_SERVER_HOST']
if given.nil? || given.empty? || given == 'nil'
  cwb_server_host = guess_public_ip
  Chef::Log.info("Detected public IP: CWB_SERVER_HOST=#{cwb_server_host}")
  node.override['cwb-server']['env']['CWB_SERVER_HOST'] = cwb_server_host
end
