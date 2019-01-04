title 'cwb-server::users'

describe user('apps') do
  it { should exist }
  its('groups') { should eq %w(apps) }
  its('home') { should eq '/home/apps' } # Required for Vagrant
end

describe user('deploy') do
  it { should exist }
  its('groups') { should eq %w(deploy apps) }
end
