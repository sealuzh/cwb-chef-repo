title 'cwb-server::nodejs'

describe command('node --version') do
  its(:stdout) { should match(/v10\.\d+\.\d+/) }
end
