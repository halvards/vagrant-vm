include fix::lucid
include go::agent
include go::server
include timezone::sydney

class go::server {
  include utils::base
  include utils::vcs
  include java::sunjdk6

  $go_version = '12.1'
  $go_build = "${go_version}.0-15089"
  $go_server_deb_file = "go-server-$go_build.deb"

  wget::fetch { 'go-server':
    source => "http://download01.thoughtworks.com/go/${go_version}/ga/${go_server_deb_file}",
    destination => "/vagrant-share/apps/${go_server_deb_file}",
  }

  package { 'go-server':
    provider => dpkg,
    ensure => installed,
    source => "/vagrant-share/apps/${go_server_deb_file}",
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
  include java::sunjdk6

  $go_version = '12.1'
  $go_build = "${go_version}.0-15089"
  $go_agent_deb_file = "go-agent-$go_build.deb"

  wget::fetch { 'go-agent':
    source => "http://download01.thoughtworks.com/go/${go_version}/ga/${go_agent_deb_file}",
    destination => "/vagrant-share/apps/${go_agent_deb_file}",
  }

  package { 'go-agent':
    provider => dpkg,
    ensure => installed,
    source => "/vagrant-share/apps/${go_agent_deb_file}",
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

