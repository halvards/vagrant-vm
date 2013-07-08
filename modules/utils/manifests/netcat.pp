class utils::netcat {
  case $operatingsystem {
    'CentOS': {
      package { 'nc':
        ensure => present,
      }
    }
    'Ubuntu': {
      package { 'netcat-openbsd':
        ensure => present,
      }
    }
  }
}

