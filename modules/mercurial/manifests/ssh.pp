class mercurial::ssh {
  package { 'mercurial-server':
    ensure => present,
  }

  group { 'hg':
    ensure => present,
    allowdupe => false,
    require => Package['mercurial-server'],
  }

  vagrant::group { 'vagrant-hg':
    group => 'hg',
    require => Group['hg'],
  }

  user { 'hg':
    ensure => present,
    gid => 'hg',
    managehome => true,
    require => Group['hg'],
  }
}

