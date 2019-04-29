git_client 'install_git_client' do
    action :install
end

git "/home/cwb/benchmarks" do
  repository node['cwb-workstation']['benchmarks_repo']
  revision 'master'
  user 'cwb'
  group 'cwb'
  action :checkout
#   action :sync # does a hard reset discarding uncommitted changes !
end
