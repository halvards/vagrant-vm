class java::sunjdk6 {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::vagrantvms

      package { 'java-1.6.0-sun':
        ensure => present,
        require => Yumrepo['vagrantvms'],
      }

      package { 'java-1.6.0-sun-devel':
        ensure => present,
        require => Package['java-1.6.0-sun'],
      }
    }
    'Ubuntu': {
      include debrepos::partner

      package { ['sun-java6-jdk', 'sun-java6-fonts', 'visualvm', 'java-common']:
        ensure => present,
        responsefile => '/vagrant-share/repos/ubuntu-sun-java-license.seeds',
        require => Exec['update-apt'],
      }
    }
  }
}

