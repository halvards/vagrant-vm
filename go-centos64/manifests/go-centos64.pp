define wgetfetch($source,$destination) {
  if $http_proxy {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => "$destination",
      timeout => 3600, # seconds
      require => Package['wget'],
      environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
    }
  } else {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => "$destination",
      timeout => 3600, # seconds
      require => Package['wget'],
    }
  }
}

class go::server {
  include utils::base
  include utils::vcs
  include utils::rpm
  include java::openjdk

  wgetfetch { 'go-server':
    source => 'http://download01.thoughtworks.com/go/2.2/ga/go-server-2.2.0-13083.noarch.rpm',
    destination => '/vagrant-share/apps/go-server-2.2.0-13083.noarch.rpm',
  }

  exec { 'fix-go-server-rpm':
    command => "/usr/bin/rpmrebuild --package --batch --notest-install --directory=/tmp/ --change-spec-requires='sed s/jdk/java-sdk/' /vagrant-share/apps/go-server-2.2.0-13083.noarch.rpm && mv /tmp/noarch/go-server-2.2.0-13083.noarch.rpm /vagrant-share/apps/go-server-2.2.0-13083.noarch.rpm && touch /vagrant-share/apps/go-server-rpm-fixed.txt",
    creates => '/vagrant-share/apps/go-server-rpm-fixed.txt',
    require => [Wgetfetch['go-server'], Package['rpm-build'], Package['rpmrebuild'], Package['sed']],
  }

  package { 'go-server':
    provider => rpm,
    ensure => installed,
    source => '/vagrant-share/apps/go-server-2.2.0-13083.noarch.rpm',
    require => [Exec['fix-go-server-rpm'], Package['java-1.6.0-openjdk'], Package['java-1.6.0-openjdk-devel'], Package['unzip']],
  }

  service { 'go-server':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['go-server'],
  }
}

class go::agent {
  include utils::base
  include utils::vcs
  include utils::rpm
  include java::openjdk

  wgetfetch { 'go-agent':
    source => 'http://download01.thoughtworks.com/go/2.2/ga/go-agent-2.2.0-13083.noarch.rpm',
    destination => '/vagrant-share/apps/go-agent-2.2.0-13083.noarch.rpm',
  }

  exec { 'fix-go-agent-rpm':
    command => "/usr/bin/rpmrebuild --package --batch --notest-install --directory=/tmp/ --change-spec-requires='sed s/jdk/java-sdk/' /vagrant-share/apps/go-agent-2.2.0-13083.noarch.rpm && mv /tmp/noarch/go-agent-2.2.0-13083.noarch.rpm /vagrant-share/apps/go-agent-2.2.0-13083.noarch.rpm && touch /vagrant-share/apps/go-agent-rpm-fixed.txt",
    creates => '/vagrant-share/apps/go-agent-rpm-fixed.txt',
    require => [Wgetfetch['go-agent'], Package['rpm-build'], Package['rpmrebuild'], Package['sed']],
  }

  package { 'go-agent':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/apps/go-agent-2.2.0-13083.noarch.rpm',
    require => [Exec['fix-go-agent-rpm'], Package['java-1.6.0-openjdk'], Package['java-1.6.0-openjdk-devel'], Package['unzip']],
  }

  service { 'go-agent':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['go-agent'],
  }
}

class java::openjdk {
  package { ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel']:
    ensure => present,
  }
}

class utils::base {
  package { ['bash', 'wget', 'curl', 'patch', 'unzip', 'sed']:
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

class utils::rpm {
  include repos::epel

  package { 'rpm-build':
    ensure => present,
  }

  package { 'rpmrebuild':
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

include go::server
include go::agent

