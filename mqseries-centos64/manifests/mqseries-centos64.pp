class mqseries::server {
  include utils::base
  include java::openjdk
  include mqseries::license
  include mqseries::users

  package { ['libXp', 'libgcc', 'libstdc++', 'compat-libstdc++-33']:
    ensure => latest,
  }

  wgetfetch { 'mqseries':
    source => 'http://www15.software.ibm.com/sdfdl/v2/fulfill/CZRW3ML/Xa.2/Xb.JSiMj8YMunaAgbdPTlIBD8cCW1hWVYyeXlYBSFKjcg/Xc.CZRW3ML/CZRW3ML.tar.gz/Xd./Xf.LPr.D1VK/Xg.6024138/Xi.ESD-WSMQ-EVAL/XY.regsrvs/XZ.UFQX8UZyWGLIb_wZpmYdbZh2iJ8/CZRW3ML.tar.gz',
    destination => '/vagrant-share/apps/CZRW3ML.tar.gz',
  }

  exec { 'extract-mqseries-rpms':
    command => '/bin/tar --ungzip --extract --directory /vagrant-share/apps/ --file /vagrant-share/apps/CZRW3ML.tar.gz',
    creates => '/vagrant-share/apps/MQSeriesRuntime-7.0.1-3.x86_64.rpm',
    require => [Wgetfetch['mqseries'], Package['tar'], Package['gzip']],
  }

  package { 'MQSeriesRuntime':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/MQSeriesRuntime-7.0.1-3.x86_64.rpm',
    require => [Exec['extract-mqseries-rpms'],
    File['/tmp/mq_license/license/status.dat'], Group['mqm'], User['mqm'], Package['libXp']],
  }

  package { 'MQSeriesServer':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/MQSeriesServer-7.0.1-3.x86_64.rpm',
    require => Package['MQSeriesRuntime'],
  }

  package { 'gsk7bas':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/gsk7bas-7.0-4.27.i386.rpm',
    require => [Package['MQSeriesRuntime'], Package['libgcc'], Package['libstdc++'], Package['compat-libstdc++-33']],
  }

  package { 'gsk7bas64':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/gsk7bas64-7.0-4.27.x86_64.rpm',
    require => [Package['MQSeriesRuntime'], Package['libgcc'], Package['libstdc++'], Package['compat-libstdc++-33']],
  }

  package { 'MQSeriesKeyMan':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/MQSeriesKeyMan-7.0.1-3.x86_64.rpm',
    require => [Package['MQSeriesRuntime'], Package['gsk7bas'], Package['gsk7bas64']],
  }

  package { 'MQSeriesJava':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/MQSeriesJava-7.0.1-3.x86_64.rpm',
    require => Package['MQSeriesRuntime'],
  }

  package { 'MQSeriesMan':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/MQSeriesMan-7.0.1-3.x86_64.rpm',
    require => [Package['MQSeriesRuntime'], Package['man']],
  }

  # Can be used to validate the installation
  package { 'MQSeriesSamples':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/MQSeriesSamples-7.0.1-3.x86_64.rpm',
    require => Package['MQSeriesServer'],
  }
}

class mqseries::users {
  group { 'mqm':
    name => 'mqm',
    allowdupe => false,
    ensure => present,
    gid => 503,
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
    uid => 101,
    require => Group['mqm'],
  }

  user { 'vagrant':
    ensure => present,
    groups => 'mqm',
    membership => minimum,
    require => Group['mqm'],
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

class java::openjdk {
  package { ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel']:
    ensure => present,
  }
}

class utils::base {
  package { ['bash', 'wget', 'curl', 'patch', 'unzip', 'sed', 'tar', 'gzip', 'man']:
    ensure => present,
  }
}

class utils::vcs {
  include repos::epel

  package { ['mercurial', 'git']:
    ensure => present,
    require => Package['epel-release'],
  }
}

class repos::epel {
  package { 'epel-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/epel-release-5-4.noarch.rpm',
  }
}

class repos::elff {
  package { 'elff-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/elff-release-5-3.noarch.rpm',
  }
}

class repos::jpackage {
  package { ['jpackage-utils', 'yum-priorities']:
    ensure => present,
  }

  package { 'jpackage-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/jpackage-release-5-4.jpp5.noarch.rpm',
    require => [Package['jpackage-utils'], Package['yum-priorities']],
  }
}

define wgetfetch($source,$destination) {
  if $http_proxy {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => "$destination",
      require => Package['wget'],
      environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
    }
  } else {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => "$destination",
      require => Package['wget'],
    }
  }
}

include repos::jpackage
#include utils::vcs
include mqseries::server

