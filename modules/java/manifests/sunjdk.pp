class java::sunjdk {
  include debrepos::partner

  package { 'sun-java6-jdk':
    ensure => present,
    responsefile => '/vagrant-share/repos/ubuntu-sun-java-license.seeds',
    require => Exec['update-apt'],
  }
}

