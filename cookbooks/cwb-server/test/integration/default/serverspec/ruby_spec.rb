require 'spec_helper'

describe 'cwb-server::ruby' do
  describe command('ruby --version') do
    its(:stdout) { should match "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]\n" }
  end

  describe command('bundle --version') do
    its(:stdout) { should match(/Bundler version 1\./) }
  end
end
