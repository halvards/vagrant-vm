include timezone::sydney
include go::agent
include go::server
include fix::lucid

class go::server {
  include utils::base
  include utils::vcs
  include java::sunjdk

  $go_version = '2.2.0-13083'

  wget::fetch { 'go-server':
    source => "http://download01.thoughtworks.com/go/2.2/ga/go-server-$go_version.deb",
    destination => "/vagrant-share/apps/go-server-$go_version.deb",
  }

  package { 'go-server':
    provider => dpkg,
    ensure => installed,
    source => "/vagrant-share/apps/go-server-$go_version.deb",
    require => [Wget::Fetch['go-server'], Package['sun-java6-jdk'], Package['unzip']],
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
  include java::sunjdk

  $go_version = '2.2.0-13083'

  wget::fetch { 'go-agent':
    source => "http://download01.thoughtworks.com/go/2.2/ga/go-agent-$go_version.deb",
    destination => "/vagrant-share/apps/go-agent-$go_version.deb",
  }

  package { 'go-agent':
    provider => dpkg,
    ensure => installed,
    source => "/vagrant-share/apps/go-agent-$go_version.deb",
    require => [Wget::Fetch['go-agent'], Package['sun-java6-jdk'], Package['unzip']],
  }

  service { 'go-agent':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['go-agent'],
  }
}

