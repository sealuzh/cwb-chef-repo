require 'spec_helper'

describe 'cwb-server::ruby' do
  let(:path) { '/usr/local/ruby-2.5.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games' }

  describe command('ruby --version') do
    its(:stdout) { should match "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]\n" }
  end

  describe command('bundle --version') do
    its(:stdout) { should match(/Bundler version 1\./) }
  end
end
