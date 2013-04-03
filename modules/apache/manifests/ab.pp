class apache::ab {
 case $operatingsystem {
    'CentOS': {
      package { '':
        ensure => present,
      }
    }
    'Ubuntu': {
      package { 'apache2-utils':
        ensure => present,
      }
    }
  }
 
}

