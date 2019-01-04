title 'cwb-server::users'

describe user('apps') do
  it { should exist }
  its('groups') { should eq %w(apps) }
  it { should have_home_directory '/home/apps' } # Required for Vagrant
end

describe user('deploy') do
  it { should exist }
  its('groups') { should eq %w(deploy apps) }
end
