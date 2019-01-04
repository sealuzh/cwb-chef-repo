title 'cwb-server::deploy_spec'

describe file('/var/www/cloud-workbench/current/Gemfile') do
  it { should be_owned_by 'deploy' }
  its(:content) { should match(%r{source 'https://rubygems.org'}) }
end

describe file('/var/www/cloud-workbench/current/storage') do
  it { should exist }
  it { should be_symlink }
end

describe file('/var/www/cloud-workbench/current/db/backups') do
  it { should exist }
  it { should be_symlink }
end

describe file('/var/www/cloud-workbench/shared/backups') do
  it { should be_directory }
  it { should be_owned_by 'apps' }
end

describe port(3000) do
  it { should be_listening }
end

describe command('wget -S -O - http://localhost:3000') do
  its(:stderr) { should match(/Connection: close/) }
  its(:stderr) { should_not match(%r{Server: nginx/1.\d+.\d+}) }
  its(:stdout) { should match(%r{<title>Cloud WorkBench</title>}) }
end

describe port(80) do
  it { should be_listening }
end

describe command('wget -S -O - http://localhost:80') do
  its(:stderr) { should match(%r{Server: nginx/1.\d+.\d+}) }
  its(:stdout) { should match(%r{<title>Cloud WorkBench</title>}) }
end

describe file('/etc/systemd/system/cloud-workbench-web@.service') do
  its(:content) { should match(/Environment="RAILS_ENV=production"/) }
end
