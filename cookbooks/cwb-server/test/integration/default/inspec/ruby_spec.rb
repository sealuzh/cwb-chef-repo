title 'cwb-server::ruby_binary'

# Alternatively prepend PATH
# path = '/usr/local/ruby-2.5.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'
bin_dir = '/usr/local/ruby-2.5.1/bin'

describe command("#{bin_dir}/ruby --version") do
  its(:stdout) { should eq "ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]\n" }
end

describe command("#{bin_dir}/gem list | grep bundle") do
  its('stdout') { should match /1\.17\.2/ }
end
