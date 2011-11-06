class tomcat::server {
  include java::sun_jdk
  include repos::jpackage

  group { 'tomcat':
    ensure  => present,
    require => Package['tomcat6'],
  }

  user { 'tomcat':
    ensure  => present,
    require => Group['tomcat'],
  }

  vagrant::group { 'vagrant-tomcat':
    group => 'tomcat',
    require => Group['tomcat'],
  }

  package { 'tomcat6':
    ensure => present,
    require => Package['jpackage-release'],
  }

  package { 'tomcat6-admin-webapps':
    ensure => present,
    notify => Service['tomcat6'],
    require => Package['tomcat6'],
  }

  service { 'tomcat6':
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => Package['java-1.6.0-sun', 'java-1.6.0-sun-devel', 'tomcat6'],
  }
}

