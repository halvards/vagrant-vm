class avahi::disable {
  case $operatingsystem {
    'CentOS': {
      package { 'avahi':
        ensure => present,
      }
    }
    'Ubuntu': {
      package { 'avahi':
        ensure => present,
        name => 'avahi-daemon',
      }
    }
  }

  service { 'avahi-daemon':
    enable => false,
    ensure => stopped,
    hasrestart => true,
    hasstatus => true,
    require => Package['avahi'],
  }
}

