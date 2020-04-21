name             'cwb-server'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
source_url       'https://github.com/sealuzh/cwb-chef-repo'
issues_url       'https://github.com/sealuzh/cwb-chef-repo/issues'
license          'Apache-2.0'
description      'Installs and configures the Cloud WorkBench server'
chef_version     '>= 14'
supports         'ubuntu'
version          '0.7.3'

### Base utilities
# depends 'apt', '~> 7.2.0'
depends 'sudo', '~> 5.4.0'
depends 'git', '~> 10.0.0'
depends 'timezone_lwrp', '~> 0.2.1'
depends 'ntp', '~> 3.7.0'

### Installation dependencies
depends 'deploy_resource', '~> 1.0.2'
depends 'postgresql', '~> 7.1.0'

### Runtime dependencies
depends 'vagrant', '~> 2.0.1'
