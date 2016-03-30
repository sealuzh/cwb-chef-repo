require 'spec_helper'

describe 'cwb-server::nodejs' do
  skip 'Enable when switching from `therubyracer` to `Node` as ExecJS' do
  describe command('node --version') do
    its(:stdout) { should match(/v5\.\d+\.\d+/) }
  end
  end
end
