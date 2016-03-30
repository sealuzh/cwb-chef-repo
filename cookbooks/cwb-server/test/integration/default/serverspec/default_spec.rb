require 'spec_helper'

describe 'cwb-server::default' do
  describe command('git --version') do
    its(:stdout) { should match(/git version 1\.\d+\.\d+/) }
  end
end
