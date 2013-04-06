class python::locust {
  include python::pip

  package { 'locustio':
    provider => pip,
    ensure   => present,
    require  => Class['python::pip'],
  }
}

