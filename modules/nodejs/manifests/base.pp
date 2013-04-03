class nodejs::base {
  include debrepos::nodejs

  package { 'nodejs':
    ensure  => present,
    require => Class['debrepos::nodejs'],
  }
}

