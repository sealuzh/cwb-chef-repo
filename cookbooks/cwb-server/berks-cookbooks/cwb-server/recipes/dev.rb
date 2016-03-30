dev = node['cwb-server']['dev']
dev['tools'].each do |tool|
  package tool do
    action :install
  end
end
