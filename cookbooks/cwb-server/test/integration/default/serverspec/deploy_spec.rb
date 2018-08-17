require 'spec_helper'

describe 'cwb-server::deploy_spec' do
  describe file('/var/www/cloud-workbench/current/Gemfile') do
    it { should be_owned_by 'apps' }
    its(:content) { should match(%r{source 'https://rubygems.org'}) }
  end

  describe port(3000) do
    it { should be_listening }
  end

  describe command('wget -O- http://localhost:3000') do
    its(:stdout) { should match(%r{<title>Cloud WorkBench</title>}) }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe command('wget -O- http://localhost:80') do
    its(:stdout) { should match(%r{<title>Cloud WorkBench</title>}) }
  end

  describe file('/etc/systemd/system/cloud-workbench-web@.service') do
    its(:content) { should match(/Environment="RAILS_ENV=production"/) }
  end
end
