class java::openjdk6 {
  case $operatingsystem {
    'CentOS': {
      package { ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel']:
        ensure => present,
      }
    }
    'Ubuntu': {
      package { 'openjdk-6-jdk':
        ensure => present,
      }
    }
  }
}

