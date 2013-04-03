class ubuntu::desktop {
  include ubuntu::updateapt

  package { 'ubuntu-desktop':
    ensure  => present,
    require => Class['ubuntu::updateapt'],
  }
}

