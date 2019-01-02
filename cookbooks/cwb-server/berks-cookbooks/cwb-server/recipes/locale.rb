# This also works in test environment vs the broken `locale`
# Chef built-in resource, which fails in containerized Ubuntu 16.04
target_locale = node['cwb-server']['system']['locale']
execute 'Set default locale' do
  command "update-locale LANG=#{target_locale}"
end
