class vagrant::user {
  group { 'vagrant':
    ensure => present,
  }

  user { 'vagrant':
    ensure => present,
    require => Group['vagrant'],
  }
}

