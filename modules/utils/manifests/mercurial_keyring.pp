class utils::mercurial_keyring {
  include utils::mercurial
  include utils::pip

  package { 'mercurial_keyring':
    provider => pip,
    ensure   => present,
    require  => [Package['mercurial'], Class['utils::pip']],
  }

  file { '/home/vagrant/.hgrc':
    ensure => present,
    source => '/vagrant-share/apps/hgrc',
  }
}

