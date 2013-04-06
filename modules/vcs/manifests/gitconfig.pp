class vcs::gitconfig {
  include vagrant::user
  include vcs::git

  file { '/home/vagrant/.gitconfig':
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 600,
    source  => '/vagrant-share/apps/gitconfig',
    require => [Group['vagrant'], User['vagrant']],
  }
}

