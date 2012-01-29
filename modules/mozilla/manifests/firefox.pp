class mozilla::firefox {
  include yumrepos::remi

  package { 'firefox':
    name    => 'firefox.x86_64',
    ensure  => present,
    require => Yumrepo['remi'],
  }
}

