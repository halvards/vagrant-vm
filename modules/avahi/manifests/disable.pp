class avahi::disable {
  package { 'avahi':
    ensure => present,
  }

  service { 'avahi-daemon':
    enable => false,
    ensure => stopped,
    hasrestart => true,
    hasstatus => true,
    require => Package['avahi'],
  }
}

