require 'spec_helper'

describe 'cwb-server::database' do
  describe command('psql --version') do
    its(:stdout) { should match(/psql \(PostgreSQL\) 9\.6\.\d+/) }
  end
  describe port(5432) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
  end
  psql_cmd = 'psql --command="\l"'
  describe command("sudo su postgres -c '#{psql_cmd}'") do
    # Encoding
    its(:stdout) { should match(/UTF8/) }
    # Locale
    its(:stdout) { should match(/en_US\.UTF-8/) }
  end
end
