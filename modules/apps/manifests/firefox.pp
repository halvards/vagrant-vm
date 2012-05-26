class apps::firefox {
  case $operatingsystem {
    'CentOS': {
      case $kernelrelease {
        /el5/: {
          package { 'firefox':
            name    => 'firefox.x86_64',
            ensure  => present,
          }
        }
        /el6/: {
          include yumrepos::remi

          package { 'firefox':
            name    => 'firefox.x86_64',
            ensure  => present,
            require => Yumrepo['remi'],
          }
        }
      }
    }
    'Ubuntu': {
      package { 'firefox':
        ensure => present,
      }
    }
  }
}

