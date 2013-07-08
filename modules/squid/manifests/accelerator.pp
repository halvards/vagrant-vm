class squid::accelerator($proxy_port = '80', $application_port = '8080') {
  include squid::base

  file { '/etc/squid3/squid.conf':
    ensure  => present,
    mode    => 664,
    owner   => 'root',
    group   => 'proxy',
    content => template('squid/squid.accelerator.conf.erb'),
    require => [Package['squid3'], Group['proxy']],
    notify  => Service['squid3'],
  }
}

