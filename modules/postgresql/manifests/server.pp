class postgresql::server {

  package { 'postgresql':
    ensure => present,
  }

  case $operatingsystem {
    'CentOS': {
      package { ['postgresql-contrib', 'postgresql-docs', 'postgresql-libs', 'postgresql-server', 'uuid-pgsql']:
        ensure  => present,
      }

      #package { ['postgresql-jdbc', 'postgresql-odbc']:
        #ensure  => present,
      #}

      exec { 'postgresql-initdb':
        command => '/sbin/service postgresql initdb',
        creates => '/var/lib/pgsql/data/pg_hba.conf',
        require => Package['postgresql-server'],
      }
    }
    'Ubuntu': {
      package { ['postgresql-contrib', 'postgresql-doc']:
        ensure => present,
      }
    }
  }

  service { 'postgresql':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => $operatingsystem ? {
      'CentOS' => Exec['postgresql-initdb'],
      'Ubuntu' => Package['postgresql'],
    },
  }
}

