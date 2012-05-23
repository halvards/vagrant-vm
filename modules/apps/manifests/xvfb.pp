# Use this when installers require an X server
class apps::xvfb {
  if ! defined(Package['xvfb']) {
    package { 'xvfb':
      name   => $operatingsystem ? {
        'CentOS' => 'xorg-x11-server-Xvfb',
        'Ubuntu' => 'xvfb',
      },
      ensure => present,
    }
  }
}

