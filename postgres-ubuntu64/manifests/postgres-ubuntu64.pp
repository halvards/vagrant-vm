include postgresql::server
include timezone::sydney
include ubuntu::disable-unattended-upgrades
include ubuntu::fixgroup
include utils::base
include utils::git

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

  exec { 'create-vagrant-postgres-role':
    command => '/usr/bin/psql --command="create role "vagrant" with superuser createdb createrole login password \'vagrant\'"',
    unless  => '/usr/bin/psql --command="\du" | /bin/grep vagrant',
    user    => 'postgres',
    require => [Service['postgresql'], User['postgres']],
  }

  exec { 'create-vagrant-database':
    command => '/usr/bin/createdb vagrant',
    unless  => '/usr/bin/psql --list | /bin/grep vagrant',
    user    => 'postgres',
    require => [Service['postgresql'], User['postgres']],
  }
}

