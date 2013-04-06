class vcs::mercurial_keyring {
  include python::pip
  include vcs::mercurial

  package { 'mercurial_keyring':
    provider => pip,
    ensure   => present,
    require  => [Package['mercurial'], Class['python::pip']],
  }

  file { '/home/vagrant/.hgrc':
    ensure => present,
    source => '/vagrant-share/apps/hgrc',
  }
}

