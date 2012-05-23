class apps::firefox {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::remi

      package { 'firefox':
        name    => 'firefox.x86_64',
        ensure  => present,
        require => Yumrepo['remi'],
      }
    }
    'Ubuntu': {
      package { 'firefox':
        ensure => present,
      }
    }
  }
}

