class python::virtualenv {
  include python::pip

  package { 'virtualenvwrapper':
    provider => pip,
    ensure   => present,
    require  => Class['python::pip'],
  }
}

