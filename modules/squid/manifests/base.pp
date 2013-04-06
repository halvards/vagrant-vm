class squid::base {
  package { 'squid3': 
    ensure => present,
  }

  group { 'proxy':
    ensure  => present,
    require => Package['squid3'],
  }

  user { 'proxy':
    ensure  => present,
    require => Group['proxy'],
  }

  vagrant::group { 'vagrant-proxy':
    group   => 'proxy',
    require => Group['proxy'],
  }

  service { 'squid3':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['squid3'],
  }
}

