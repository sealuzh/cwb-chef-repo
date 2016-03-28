name             'cwb-server'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs and configures the Cloud WorkBench server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

### Base utilities
depends 'sudo', '~> 2.9'
depends 'apt', '~> 3.0'
depends 'build-essential', '~> 3.2.0'
depends 'git', '~> 4.4'
# Github: https://github.com/L2G/timezone-ii
# Alternative: https://github.com/engineyard/ey-cloud-recipes/tree/master/cookbooks/timezone
depends 'timezone-ii', '~> 0.2.0'
depends 'ntp', '~> 1.10.1'

### Installation dependencies
depends 'database', '~> 5.0.0'
depends 'postgresql', '~> 4.0.4'

### Runtime dependencies
depends 'vagrant', '~> 0.5.0'

### Deployment
# If using Capistrano
# depends 'acl', '~> 1.0.2'
