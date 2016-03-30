deploy_revision node['cwb-server']['app']['name'] do
  action :rollback
end
