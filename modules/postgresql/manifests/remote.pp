class postgresql::remote {
  include postgresql::server

  $postgresql_conf_directory = $operatingsystem ? {
    'CentOS' => '/var/lib/pgsql/data',
    'Ubuntu' => '/etc/postgresql/9.1/main',
  }

  line::commentout { 'postgresql-disable-localhost-only-restriction':
    line    => 'host\s+all\s+all\s+127.0.0.1\/32\s+md5',
    file    => "${postgresql_conf_directory}/pg_hba.conf",
    notify  => Service['postgresql'],
    require => $operatingsystem ? {
      'CentOS' => Exec['postgresql-initdb'],
      'Ubuntu' => Package['postgresql'],
    },
  }

  line::present { 'postgresql-allow-connections-from-anywhere':
    line => 'host all all 0.0.0.0/0 md5',
    file => "${postgresql_conf_directory}/pg_hba.conf",
    notify  => Service['postgresql'],
    require => $operatingsystem ? {
      'CentOS' => Exec['postgresql-initdb'],
      'Ubuntu' => Package['postgresql'],
    },
  }

  line::present { 'postgresql-listen-on-all-network-interfaces':
    line    => "listen_addresses = '\\''*'\\''",
    file    => "${postgresql_conf_directory}/postgresql.conf",
    notify  => Service['postgresql'],
    require => $operatingsystem ? {
      'CentOS' => Exec['postgresql-initdb'],
      'Ubuntu' => Package['postgresql'],
    },
  }
}

