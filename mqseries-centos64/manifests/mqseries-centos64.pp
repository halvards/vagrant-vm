include mqseries::server
include timezone::sydney

class mqseries::server {
  include utils::base
  include java::openjdk
  include mqseries::license
  include mqseries::users

  $mqseries_tarball = '/vagrant-share/apps/CZRW3ML.tar.gz'
  $mqseries_rpm_dir = '/vagrant-share/apps/mqseries'
  $queue_manager_name = 'TESTQMGR'

  package { ['libXp', 'libgcc', 'libstdc++', 'compat-libstdc++-33']:
    ensure => latest,
  }

  wget::fetch { 'mqseries':
    source => 'http://www15.software.ibm.com/sdfdl/v2/fulfill/CZRW3ML/Xa.2/Xb.JSiMj8YMunaAgbdPTlIBD8cCW1hWVYyeXlYBSFKjcg/Xc.CZRW3ML/CZRW3ML.tar.gz/Xd./Xf.LPr.D1VK/Xg.6024138/Xi.ESD-WSMQ-EVAL/XY.regsrvs/XZ.UFQX8UZyWGLIb_wZpmYdbZh2iJ8/CZRW3ML.tar.gz',
    destination => "$mqseries_tarball",
  }

  exec { 'extract-mqseries-rpms':
    command => "/bin/mkdir -p $mqseries_rpm_dir && /bin/tar --ungzip --extract --directory $mqseries_rpm_dir/ --file $mqseries_tarball",
    creates => "$mqseries_rpm_dir/MQSeriesRuntime-7.0.1-3.x86_64.rpm",
    require => [Wget::Fetch['mqseries'], Package['tar'], Package['gzip']],
  }

  package { 'MQSeriesRuntime':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/MQSeriesRuntime-7.0.1-3.x86_64.rpm",
    require => [Exec['extract-mqseries-rpms'], File['/tmp/mq_license/license/status.dat'], Group['mqm'], User['mqm'], Package['libXp']],
  }

  package { 'MQSeriesServer':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/MQSeriesServer-7.0.1-3.x86_64.rpm",
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

  package { 'gsk7bas':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/gsk7bas-7.0-4.27.i386.rpm",
    require => [Package['MQSeriesRuntime'], Package['libgcc'], Package['libstdc++'], Package['compat-libstdc++-33']],
  }

  package { 'gsk7bas64':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/gsk7bas64-7.0-4.27.x86_64.rpm",
    require => [Package['MQSeriesRuntime'], Package['libgcc'], Package['libstdc++'], Package['compat-libstdc++-33']],
  }

  package { 'MQSeriesKeyMan':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/MQSeriesKeyMan-7.0.1-3.x86_64.rpm",
    require => [Package['MQSeriesRuntime'], Package['gsk7bas'], Package['gsk7bas64']],
  }

  package { 'MQSeriesJava':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/MQSeriesJava-7.0.1-3.x86_64.rpm",
    require => Package['MQSeriesRuntime'],
  }

  package { 'MQSeriesMan':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/MQSeriesMan-7.0.1-3.x86_64.rpm",
    require => [Package['MQSeriesRuntime'], Package['man']],
  }

  # Can be used to validate the installation
  package { 'MQSeriesSamples':
    provider => rpm,
    ensure => present,
    source => "$mqseries_rpm_dir/MQSeriesSamples-7.0.1-3.x86_64.rpm",
    require => Package['MQSeriesServer'],
  }
}

class mqseries::users {
  group { 'mqm':
    name => 'mqm',
    allowdupe => false,
    ensure => present,
    gid => 545,
  }

  user { 'mqm':
    name => 'mqm',
    allowdupe => false,
    comment => 'MQSeries admin user',
    ensure => present,
    gid => 'mqm',
    home => '/var/mqm',
    managehome => true,
    shell => '/bin/bash',
    uid => 145,
    require => Group['mqm'],
  }

  vagrant::group { 'vagrant-mqm':
    group => 'mqm',
  }
}

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

