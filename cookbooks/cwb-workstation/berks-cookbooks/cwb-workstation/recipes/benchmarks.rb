package 'sysbench'

# Download specific version (only if not already present)
fio_version = node['fio']['version']
fio_source_url = "http://brick.kernel.dk/snaps/fio-#{fio_version}.tar.gz"
remote_file "/opt/fio-#{fio_version}.tar.gz" do
  source fio_source_url
  action :create_if_missing
  notifies :run, "bash[install_fio]", :immediately
end

# Build specific version from source
bash "install_fio" do
 cwd '/opt'
 code "tar xzf fio-#{fio_version}.tar.gz && cd fio-#{fio_version} && ./configure && make && make install"
 action :nothing
end
