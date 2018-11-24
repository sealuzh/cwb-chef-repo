name             'cwb-server'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
source_url       'https://github.com/sealuzh/cwb-chef-repo'
issues_url       'https://github.com/sealuzh/cwb-chef-repo/issues'
license          'Apache-2.0'
description      'Installs and configures the Cloud WorkBench server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version     '>= 13'
supports         'ubuntu'
version          '0.6.0'

### Base utilities
depends 'apt', '~> 7.1.1'
depends 'sudo', '~> 5.4.0'
depends 'git', '~> 9.0.1'
depends 'timezone_lwrp', '~> 0.2.1'
depends 'ntp', '~> 3.6.0'

### Installation dependencies
depends 'deploy_resource', '~> 1.0.2'
depends 'postgresql', '~> 7.1.0'

### Runtime dependencies
depends 'vagrant', '~> 0.9.1'
