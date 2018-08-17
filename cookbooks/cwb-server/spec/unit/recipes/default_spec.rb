require 'spec_helper'

describe 'cwb-server::default' do
  context 'When all attributes are default, on Ubuntu 16.0' do
    before do
      stub_command("which sudo")
      stub_command("ls /var/lib/postgresql/9.6/main/recovery.conf")
      stub_command("test -f /usr/local/ruby-2.5.1/bin/bundle")
    end
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
