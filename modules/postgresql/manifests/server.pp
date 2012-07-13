class postgresql::server {
  $postgresql_conf_directory = '/etc/postgresql/9.1/main'

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

  line::commentout { 'postgresql-disable-localhost-only-restriction':
    line    => 'host\s+all\s+all\s+127.0.0.1\/32\s+md5',
    file    => "${postgresql_conf_directory}/pg_hba.conf",
    require => Package['postgresql'],
    notify  => Service['postgresql'],
  }

  line::present { 'postgresql-allow-connections-from-anywhere':
    line => 'host all all 0.0.0.0/0 md5',
    file => "${postgresql_conf_directory}/pg_hba.conf",
    notify  => Service['postgresql'],
    require => Package['postgresql'],
  }

  line::present { 'postgresql-listen-on-all-network-interfaces':
    line    => "listen_addresses = '\\''*'\\''",
    file    => "${postgresql_conf_directory}/postgresql.conf",
    require => Package['postgresql'],
    notify  => Service['postgresql'],
  }

  service { 'postgresql':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
                   Package['postgresql'],
                   Line::Commentout['postgresql-disable-localhost-only-restriction'],
                   Line::Present['postgresql-allow-connections-from-anywhere'],
                   Line::Present['postgresql-listen-on-all-network-interfaces'],
                  ],
  }
}

