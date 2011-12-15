class java::openjdk7 {
  case $operatingsystem {
    'CentOS': {
    }
    'Ubuntu': {
      package { 'openjdk-7-jdk':
        ensure => present,
      }
    }
  }
}

