class timezone::sydney {
  package { ['tzdata', 'ntp']:
    ensure => installed,
  }

  file { '/etc/timezone':
    ensure => present,
    source => '/vagrant-share/conf/timezone',
    owner => 'root',
    group => 'root',
  }

  exec { 'update-timezone':
    command => '/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata',
    require => [File['/etc/timezone'], Package['tzdata'], Package['ntp']],
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

define uncomment($line,$file) {
  exec { "sed-$name":
    command => "/bin/sed --regexp-extended --in-place 's/#+\s+($line.*)/\1/' $file",
    unless => "/bin/grep --extended-regexp '^$line' $file",
  }
}

class utils::base {
  package { ['bash', 'wget', 'curl', 'patch', 'unzip']:
    ensure => present,
  }
}

class utils::vcs {
  package { ['mercurial', 'git-core']:
    ensure => latest,
  }
}

class repos::partner {
  uncomment { 'partner-repo':
    line => 'deb.* http:\/\/archive.canonical.com\/ubuntu lucid partner',
    file => '/etc/apt/sources.list',
  }

  exec { 'update-apt':
    command => '/usr/bin/apt-get update',
    require => Uncomment['partner-repo'],
  }
}

class java::sunjdk {
  include repos::partner

  package { 'sun-java6-jdk':
    ensure => present,
    responsefile => '/vagrant-share/repos/ubuntu-sun-java-license.seeds',
    require => Exec['update-apt'],
  }
}

class go::server {
  include utils::base
  include utils::vcs
  include java::sunjdk

  wgetfetch { 'go-server':
    source => 'http://download01.thoughtworks.com/go/2.2.1/patch/go-server-2.2.1-13139.deb',
    destination => '/vagrant-share/apps/go-server-2.2.1-13139.deb',
  }

  package { 'go-server':
    provider => dpkg,
    ensure => installed,
    source => '/vagrant-share/apps/go-server-2.2.1-13139.deb',
    require => [Wgetfetch['go-server'], Package['sun-java6-jdk'], Package['unzip']],
  }

  service { 'go-server':
    ensure => running,
    require => Package['go-server'],
  }
}

class go::agent {
  include utils::base
  include utils::vcs
  include java::sunjdk

  wgetfetch { 'go-agent':
    source => 'http://download01.thoughtworks.com/go/2.2.1/patch/go-agent-2.2.1-13139.deb',
    destination => '/vagrant-share/apps/go-agent-2.2.1-13139.deb',
  }

  package { 'go-agent':
    provider => dpkg,
    ensure => installed,
    source => '/vagrant-share/apps/go-agent-2.2.1-13139.deb',
    require => [Wgetfetch['go-agent'], Package['sun-java6-jdk']],
  }

  service { 'go-agent':
    ensure => running,
    require => Package['go-agent'],
  }
}

include timezone::sydney
include go::server
include go::agent

