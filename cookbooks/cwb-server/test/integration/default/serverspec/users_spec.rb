require 'spec_helper'

describe 'cwb-server::users' do
  describe user('apps') do
    it { should exist }
    it { should belong_to_group 'apps' }
    it { should have_home_directory '/home/apps' } # Required for Vagrant
  end

  describe user('deploy') do
    it { should exist }
    it { should belong_to_group 'apps' }
  end
end
