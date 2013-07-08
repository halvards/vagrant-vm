class python::locust {
  include python::pip

  if ! defined(Package['libevent-dev']) {
    package { 'libevent-dev':
      ensure => present,
    }
  }

  package { 'locustio':
    provider => pip,
    ensure   => present,
    require  => [Package['libevent-dev'], Class['python::pip']],
  }
}

