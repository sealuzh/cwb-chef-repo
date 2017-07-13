require 'spec_helper'

describe 'cwb-server::ruby' do
  describe command('ruby --version') do
    its(:stdout) { should match "ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]\n" }
  end

  describe command('bundle --version') do
    its(:stdout) { should match(/Bundler version 1\./) }
  end
end
