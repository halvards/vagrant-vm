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

include timezone::sydney
include utils::base
include utils::vcs
include repos::partner

