dev = node['cwb-server']['dev']
dev['tools'].each do |tool|
  package tool do
    action :install
  end
end

# Required for running integration test.
# Usually installed by default but not in certain Docker images!
package 'net-tools'
package 'wget'
