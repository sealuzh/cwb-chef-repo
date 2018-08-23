require 'spec_helper'

describe 'cwb-server::default' do
  context 'When all attributes are default, on Ubuntu 16.0' do
    ruby_version = '2.5.1'
    postgresql_version = '9.6'

    before do
      stub_command('which sudo')
      stub_command("ls /var/lib/postgresql/#{postgresql_version}/main/recovery.conf")
      stub_command("test -f /usr/local/ruby-#{ruby_version}/bin/bundle").and_return(false)
      stub_command("test -f /usr/local/ruby-#{ruby_version}/bin/ruby_executable_hooks").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        # ...
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'sets the Ruby source URL' do
      expect(chef_run.node['cwb-server']['ruby']['source_url']).to eq("https://rvm.io/binaries/ubuntu/16.04/x86_64/ruby-#{ruby_version}.tar.bz2")
    end

    it 'installs nginx' do
      expect(chef_run).to install_package('nginx')
    end
  end
end
