class utils::mercurial_pip {
  include repos::epel

  package { 'python':
    ensure => present,
  }

  package { ['python-devel', 'python-docutils']:
    ensure => present,
    require => Package['python'],
  }

  package { 'python-pip':
    ensure => present,
    require => Package['epel-release', 'python'],
  }

  file { '/usr/bin/pip':
    ensure => link,
    target => '/usr/bin/pip-python',
    require => Package['python-pip'],
  }

  package { 'mercurial':
    provider => pip,
    ensure => present,
    require => [File['/usr/bin/pip'], Package['python-devel', 'python-docutils']],
  }

  package { 'keyring':
    provider => pip,
    ensure => present,
    require => File['/usr/bin/pip'],
  }

  package { 'mercurial_keyring':
    provider => pip,
    ensure => present,
    require => Package['keyring', 'mercurial'],
  }

  file { '/home/vagrant/.hgrc':
    ensure => present,
    source => '/vagrant-share/apps/hgrc',
    require => Package['mercurial_keyring'],
  }
}

