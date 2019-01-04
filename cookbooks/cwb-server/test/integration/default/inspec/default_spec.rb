title 'cwb-server::default'

describe command('git --version') do
  its(:stdout) { should match(/git version 2\.\d+\.\d+/) }
end
