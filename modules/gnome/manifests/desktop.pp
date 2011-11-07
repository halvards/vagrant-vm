class gnome::desktop {
  include debrepos::exclude_recommended

  package { 'ubuntu-desktop':
    ensure => present,
    require => File['/etc/apt/apt.conf'],
  }
}

