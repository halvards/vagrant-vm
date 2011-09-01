class mozilla::firefox {
  package { 'firefox':
    name => 'firefox.x86_64',
    ensure => present,
  }
}

