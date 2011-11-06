class mqseries::license {
  file { '/tmp/mq_license':
    ensure => directory,
  }

  file { '/tmp/mq_license/license':
    ensure => directory,
    require => File['/tmp/mq_license'],
  }

  file { '/tmp/mq_license/license/status.dat':
    ensure => present,
    source => '/vagrant-share/conf/mq-license-status.dat',
    require => File['/tmp/mq_license/license'],
  }
}

