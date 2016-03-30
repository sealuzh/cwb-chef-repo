require 'spec_helper'

describe 'cwb-server::nginx' do
  describe file('/etc/nginx') do
    it { should be_directory }
  end

  describe command('/usr/sbin/nginx -v') do
    its(:stderr) { should match(%r{nginx version: nginx/1\.\d+\.\d+}) }
  end

  describe file('/etc/nginx/sites-enabled/default') do
    it { should_not exist }
  end

  describe file('/etc/nginx/sites-enabled/cloud-workbench') do
    it { should exist }
  end
end
