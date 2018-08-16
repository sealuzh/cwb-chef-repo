require 'spec_helper'

describe 'cwb-server::secrets' do
  describe file('/home/apps/.ssh/cloud-benchmarking.pem') do
    its(:content) { should match(/-----BEGIN RSA PRIVATE KEY-----/) }
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

  describe file('/home/apps/.chef/knife.rb') do
    skip 'Not mandatory, but might be helpful as admin tool' do
    its(:content) { should match(/node_name\s+'cwb-server'/) }
    end
  end

  # Providers
  providers_dir = '/home/apps/providers'
  google_file = "#{providers_dir}/google/google-compute.pem"
  azure_file = "#{providers_dir}/azure/azure.pem"
  describe file('/etc/systemd/system/cloud-workbench-job@.service') do
    its(:content) { should match(/Environment="AWS_ACCESS_KEY=my_aws_access_key"/) }
    its(:content) { should match(/Environment="GOOGLE_API_KEY_NAME=google-compute"/) }
    its(:content) { should match(%r{Environment="GOOGLE_API_KEY_PATH=#{google_file}"}) }
    its(:content) { should match(/Environment="AZURE_MGMT_CERTIFICATE_PATH=#{azure_file}"/) }
    its(:content) { should match(%r{Environment="CHEF_SERVER_URL=https://33.33.33.10:443/organizations/chef"}) }
    its(:content) { should match(/Environment="CWB_SERVER_HOST=\d+\.\d+\.\d+.\d+"/) }
    # Contains Ruby PATH
    its(:content) { should match(/Environment="PATH=\/usr\/local\/ruby-\d\.\d+\.\d+\/bin:.*"/) }
  end

  describe file(google_file) do
    its(:content) { should eq('my_google_compute_key') }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end

  describe file(azure_file) do
    its(:content) { should eq('my_azure_certificate_file_content') }
    it { should be_mode 600 }
    it { should be_owned_by 'apps' }
  end
end
