class postgresql::server {
  package { 'postgresql':
    ensure   => present,
  }

  group { 'postgres':
    ensure  => present,
    require => Package['postgresql'],
  }

  user { 'postgres':
    ensure => present,
    require => Group['postgres'],
  }

  vagrant::group { 'vagrant-postgres':
    group => 'postgres',
    require => Group['postgres'],
  }

  service { 'postgresql':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['postgresql'],
  }
}

