name             'cwb-workstation'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache-2.0'
description      'Installs/Configures cwb-workstation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'
chef_version     '>= 14'
supports         'ubuntu'

depends 'chef-dk', '~> 3.1.0'
depends 'git', '~> 9.0.1'
