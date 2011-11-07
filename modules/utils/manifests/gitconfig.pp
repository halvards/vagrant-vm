class utils::gitconfig {
  include utils::git
  include vagrant::user

  file { '/home/vagrant/.gitconfig':
    ensure => present,
    owner => 'vagrant',
    group => 'vagrant',
    mode => 600,
    source => '/vagrant-share/apps/gitconfig',
    require => [Group['vagrant'], User['vagrant']],
  }
}

