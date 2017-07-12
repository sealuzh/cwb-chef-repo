name             'cwb-server'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs and configures the Cloud WorkBench server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'

### Base utilities
depends 'sudo', '~> 3.5.2'
depends 'apt', '>= 6.1.2'
depends 'build-essential', '>= 8.0.3'
depends 'git', '>= 6.1.0'
# Github: https://github.com/L2G/timezone-ii
# Alternative: https://github.com/engineyard/ey-cloud-recipes/tree/master/cookbooks/timezone
depends 'timezone-ii', '~> 0.2.0'
depends 'ntp', '~> 3.5.0'

### Installation dependencies
depends 'database', '~> 6.1.1'
depends 'postgresql', '~> 6.1.1'

### Runtime dependencies
depends 'vagrant', '~> 0.7.0'
