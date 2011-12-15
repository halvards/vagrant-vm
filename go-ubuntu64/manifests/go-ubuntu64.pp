include timezone::sydney
#include go::agent
#include go::server
include fix::lucid

class go::server {
  include utils::base
  include utils::vcs
  include java::openjdk6

  $go_version = '2.4.0'
  $go_build = "$go_version-14481"

  wget::fetch { 'go-server':
    source => "http://download01.thoughtworks.com/go/$go_version/ga/go-server-$go_build.deb",
    destination => "/vagrant-share/apps/go-server-$go_build.deb",
  }

  package { 'go-server':
    provider => dpkg,
    ensure => installed,
    source => "/vagrant-share/apps/go-server-$go_build.deb",
    require => [Wget::Fetch['go-server'], Package['openjdk-6-jdk'], Package['unzip']],
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
  include java::openjdk6

  $go_version = '2.4.0'
  $go_build = "$go_version-14481"

  wget::fetch { 'go-agent':
    source => "http://download01.thoughtworks.com/go/$go_version/ga/go-agent-$go_build.deb",
    destination => "/vagrant-share/apps/go-agent-$go_build.deb",
  }

  package { 'go-agent':
    provider => dpkg,
    ensure => installed,
    source => "/vagrant-share/apps/go-agent-$go_build.deb",
    require => [Wget::Fetch['go-agent'], Package['openjdk-6-jdk'], Package['unzip']],
  }

  service { 'go-agent':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['go-agent'],
  }
}

