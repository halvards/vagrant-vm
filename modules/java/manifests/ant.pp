class java::ant {
  package { 'ant':
    ensure => present,
  }

  package { 'ant-contrib':
    ensure  => present,
    require => Package['ant'],
  }
}

