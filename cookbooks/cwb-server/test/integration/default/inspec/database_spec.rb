title 'cwb-server::database'

describe command('psql --version') do
  its(:stdout) { should match(/psql \(PostgreSQL\) 9\.6\.\d+/) }
end

describe port(5432) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '127.0.0.1' }
end

psql_cmd = 'psql --command="\l"'
describe command("sudo su postgres -c '#{psql_cmd}'") do
  # Encoding
  its(:stdout) { should match(/UTF8/) }
  # Locale
  its(:stdout) { should match(/en_US\.UTF-8/) }
end
