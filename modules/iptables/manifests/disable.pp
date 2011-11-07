class iptables::disable {
  case $operatingsystem {
    'CentOS': {
      package { 'iptables':
        ensure => present,
      }

      service { 'iptables':
        enable => false,
        ensure => stopped,
        hasrestart => true,
        hasstatus => true,
        require => Package['iptables'],
      }
    }
    'Ubuntu': {
      package { 'ufw':
        ensure => present,
      }

      service { 'ufw':
        enable => false,
        ensure => stopped,
        hasrestart => true,
        hasstatus => true,
        require => Package['ufw'],
      }
    }
  }
}

