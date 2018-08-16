require 'spec_helper'

def cmd_as_user(cmd, user = 'apps')
  # -H set HOME to target user
  "sudo -H -u #{user} bash -c '#{cmd}'"
end

describe 'cwb-server::vagrant' do
  describe command(cmd_as_user('vagrant --version')) do
    its(:stdout) { should match(/Vagrant 2\.\d+\.\d+/) }
  end

  describe command(cmd_as_user('vagrant plugin list')) do
    its(:stdout) { should match(/vagrant-omnibus/) }
  end
end
