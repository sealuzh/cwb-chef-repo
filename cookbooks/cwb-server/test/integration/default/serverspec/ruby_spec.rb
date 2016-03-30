require 'spec_helper'

describe 'cwb-server::ruby' do
  describe command('ruby --version') do
    its(:stdout) { should match "ruby 2.2.4p230 (2015-12-16 revision 53155) [x86_64-linux]\n" }
  end

  describe command('bundle --version') do
    its(:stdout) { should match(/Bundler version 1\./) }
  end
end
