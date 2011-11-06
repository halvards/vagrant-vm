class mqseries::server {
  include utils::base
  include mqseries::runtime

  $queue_manager_name = 'TESTQMGR'

  package { 'MQSeriesServer':
    ensure => present,
    require => Package['MQSeriesRuntime'],
  }

  exec { 'create-test-queue-manager':
    command => "/usr/bin/crtmqm -q -u SYSTEM.DEAD.LETTER.QUEUE $queue_manager_name",
    creates => "/var/mqm/qmgrs/$queue_manager_name",
    logoutput => true,
    user => 'mqm',
    group => 'mqm',
    require => Package['MQSeriesServer'],
  }

  exec { 'start-test-queue-manager':
    command => "/usr/bin/strmqm $queue_manager_name",
    returns => [0, 3, 5],
    logoutput => true,
    user => 'mqm',
    group => 'mqm',
    require => Exec['create-test-queue-manager'],
  }

  exec { 'create-test-queues':
    command => '/usr/bin/runmqsc < /vagrant-share/conf/mqseries-setup.script',
    creates => "/var/mqm/qmgrs/$queue_manager_name/queues/TEST!ECHO!MESSAGE!QUEUE/q",
    logoutput => true,
    user => 'mqm',
    group => 'mqm',
    require => Exec['start-test-queue-manager'],
  }
}

