class java::openjdk7 {
  case $operatingsystem {
    'CentOS': {
      package { ['java-1.7.0-openjdk', 'java-1.7.0-openjdk-devel']:
        ensure => present,
      }
    }
    'Ubuntu': {
      package { 'openjdk-7-jdk':
        ensure => present,
      }
    }
  }
}

