class sonar::user {
  user { 'sonar':
    ensure   => present,
    shell    => '/bin/sh',
  }

  group { 'sonar':
    ensure  => present,
    system  => false,
    require => User['sonar'],
  }

  vagrant::group { 'vagrant-sonar':
    group => 'sonar',
  }
}

