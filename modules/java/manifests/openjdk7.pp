class java::openjdk7 {
  case $operatingsystem {
    'CentOS': {
      include java::oraclejdk7
    }
    'Ubuntu': {
      package { 'openjdk-7-jdk':
        ensure => present,
      }
    }
  }
}

