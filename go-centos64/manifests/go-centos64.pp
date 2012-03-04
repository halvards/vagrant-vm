include timezone::sydney
include go::agent
include go::server

class go::server {
  include utils::base
  include utils::vcs
  include utils::rpm
  include java::openjdk6

  $go_version = '12.1'
  $go_build = "${go_version}.0-15089"
  $go_server_rpm_file = "go-server-$go_build.noarch.rpm"
  $go_server_local_file = "/vagrant-share/apps/$go_server_rpm_file"
  $go_server_md5_checksum = 'c3d3e09b678552c5f6a42eb5339b65dc'

  wget::fetch { 'go-server':
    source => "http://download01.thoughtworks.com/go/$go_version/ga/go-server-$go_build.noarch.rpm",
    destination => "$go_server_local_file",
  }

  # note the significant two spaces between $go_server_md5_checksum and $go_server_local_file
  exec { 'fix-go-server-rpm':
    command => "/usr/bin/rpmrebuild --package --batch --notest-install --directory=/tmp/ --change-spec-requires='sed s/jdk/java-sdk/' $go_server_local_file && mv /tmp/noarch/$go_server_rpm_file $go_server_local_file",
    unless => "/bin/bash -c '[ \"`/usr/bin/md5sum $go_server_local_file`\" = \"$go_server_md5_checksum  $go_server_local_file\" ] && /bin/true || /bin/false'",
    require => [Wget::Fetch['go-server'], Package['rpm-build'], Package['rpmrebuild'], Package['sed'], Package['bash'], Package['coreutils']],
  }

  package { 'go-server':
    provider => rpm,
    ensure => installed,
    source => "$go_server_local_file",
    require => [Exec['fix-go-server-rpm'], Package['java-1.6.0-openjdk-devel'], Package['unzip']],
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
  include java::openjdk6

  $go_version = '12.1'
  $go_build = "${go_version}.0-15089"
  $go_agent_rpm_file = "go-agent-$go_build.noarch.rpm"
  $go_agent_local_file = "/vagrant-share/apps/$go_agent_rpm_file"
  $go_agent_md5_checksum = '879ac18d6a51703532c5ae7f5b5cdb64'

  wget::fetch { 'go-agent':
    source => "http://download01.thoughtworks.com/go/$go_version/ga/go-agent-$go_build.noarch.rpm",
    destination => "$go_agent_local_file",
  }

  # note the significant two spaces between $go_agent_md5_checksum and $go_agent_local_file
  exec { 'fix-go-agent-rpm':
    command => "/usr/bin/rpmrebuild --package --batch --notest-install --directory=/tmp/ --change-spec-requires='sed s/jdk/java-sdk/' $go_agent_local_file && mv /tmp/noarch/$go_agent_rpm_file $go_agent_local_file",
    unless => "/bin/bash -c '[ \"`/usr/bin/md5sum $go_agent_local_file`\" = \"$go_agent_md5_checksum  $go_agent_local_file\" ] && /bin/true || /bin/false'",
    require => [Wget::Fetch['go-agent'], Package['rpm-build'], Package['rpmrebuild'], Package['sed'], Package['bash'], Package['coreutils']],
  }

  package { 'go-agent':
    provider => rpm,
    ensure => present,
    source => "$go_agent_local_file",
    require => [Exec['fix-go-agent-rpm'], Package['java-1.6.0-openjdk-devel'], Package['unzip']],
  }

  service { 'go-agent':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['go-agent'],
  }
}

