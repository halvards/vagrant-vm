class activemq::singlecollective {
  include activemq::broker

  file { '/etc/activemq/activemq.xml':
    ensure  => present,
    owner  => 'activemq',
    group  => 'activemq',
    mode   => 664,
    source  => '/vagrant-share/conf/activemq/activemq-singlecollective.xml',
    require => [Package['activemq'], User['activemq'], Group['activemq']],
    notify  => Service['activemq'],
  }
}

