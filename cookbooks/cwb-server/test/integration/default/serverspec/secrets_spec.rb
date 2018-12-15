require 'spec_helper'

describe 'cwb-server::secrets' do
  describe file('/home/apps/.ssh/cloud-benchmarking.pem') do
    its(:content) { should match(/-----BEGIN OPENSSH PRIVATE KEY-----/) }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end

  describe file('/home/apps/.ssh/cloud-benchmarking.pem.pub') do
    its(:content) { should eq "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDSns2ln6lkzBopBV1MuxCM6+oba3OXmW7ihQ2Bjo8bvkMXIwbbk+4L89xW7X7mU4SPmFkk0WdRt1PxQIshahGUYEydbRfXUogcP6ohqyF0Zrxz5/uRfumF/T9OLK4sQPtGbh9NJPljHtccdkgXiCor7K/ZLIlHb2LS4FU2xqNSNQ== cwb@test.com\n" }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end

  describe file('/home/apps/.chef/chef-validator.pem') do
    its(:content) { should match(/-----BEGIN RSA PRIVATE KEY-----/) }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end

  describe file('/home/apps/.chef/cwb-server.pem') do
    its(:content) { should match(/-----BEGIN RSA PRIVATE KEY-----/) }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end

  # Steps to implement this:
  # 1) Add `/opt/chef/bin/` to path
  # 2) Generate `knife.rb`
  # describe file('/home/apps/.chef/knife.rb') do
  #   skip 'Not mandatory, but might be helpful as admin tool' do
  #     its(:content) { should match(/node_name\s+'cwb-server'/) }
  #   end
  # end

  # Providers
  providers_dir = '/home/apps/providers'
  google_file = "#{providers_dir}/google/google.pem"
  describe file('/etc/systemd/system/cloud-workbench-job@.service') do
    its(:content) { should match(/Environment="AWS_ACCESS_KEY=my_aws_access_key"/) }
    its(:content) { should match(/Environment="GOOGLE_PROJECT_ID=my_google_project_id"/) }
    its(:content) { should match(/Environment="GOOGLE_JSON_KEY_PATH=#{google_file}"/) }
    its(:content) { should match(/Environment="AZURE_TENANT_ID=my_azure_tenant_id"/) }
    its(:content) { should match(%r{Environment="CHEF_SERVER_URL=https://33.33.33.10:443/organizations/chef"}) }
    its(:content) { should match(/Environment="CWB_SERVER_HOST=\d+\.\d+\.\d+.\d+"/) }
    # Contains Ruby PATH
    its(:content) { should match(%r{Environment="PATH=/usr/local/ruby-\d\.\d+\.\d+\/bin:.*"}) }
  end

  describe file(google_file) do
    its(:content) { should eq('{"google": "my_google_secret"}') }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end
end
