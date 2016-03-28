require 'serverspec'

# Serverspec examples can be found at
# http://serverspec.org/resource_types.html

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end
