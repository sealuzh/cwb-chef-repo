require 'spec_helper'

describe 'cwb-server::nodejs' do
  describe command('node --version') do
    its(:stdout) { should match(/v10\.\d+\.\d+/) }
  end
end
