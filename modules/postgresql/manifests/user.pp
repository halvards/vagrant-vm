class postgresql::user {
  include postgresql::server

  group { 'postgres':
    ensure  => present,
    require => $operatingsystem ? {
      'CentOS' => Package['postgresql-server'],
      'Ubuntu' => Package['postgresql'],
    },
  }

  user { 'postgres':
    ensure  => present,
    require => Group['postgres'],
  }

  vagrant::group { 'vagrant-postgres':
    group   => 'postgres',
    require => Group['postgres'],
  }
}

