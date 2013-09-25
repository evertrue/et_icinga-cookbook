name             'et_icinga'
maintainer       'EverTrue, Inc.'
maintainer_email 'eric.herot@evertrue.com'
license          'All rights reserved'
description      'Installs/Configures et_icinga'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

depends 'icinga', '= 1.0.1'
depends 'build-essential'
depends 'apache2'
depends 'apt'
