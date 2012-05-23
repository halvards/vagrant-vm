class apps::skype {
  include debrepos::partner

  package { 'skype':
    ensure  => present,
    require => Class['debrepos::partner'],
  }
}

