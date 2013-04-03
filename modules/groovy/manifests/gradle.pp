class groovy::gradle {
  include debrepos::gradle

  package { 'gradle':
    ensure  => present,
    require => Class['debrepos::gradle'],
  }
}

