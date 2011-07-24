class iptables::disable {
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

