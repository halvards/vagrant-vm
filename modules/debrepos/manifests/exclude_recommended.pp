class debrepos::exclude_recommended {
  file { '/etc/apt/apt.conf':
    ensure => present,
    source => '/vagrant-share/conf/apt.conf',
  }
}

