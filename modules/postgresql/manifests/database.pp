define postgresql::database($database) {
  exec { "create-${database}-database":
    command => "/usr/bin/createdb ${database}",
    unless  => "/usr/bin/psql --list | /bin/grep ${database}",
    user    => 'postgres',
    require => [Service['postgresql'], User['postgres']],
  }

  postgresql::extension { 'enable-postgresql-extension-hstore-for-database-vagrant':
    database  => 'vagrant',
    extension => 'hstore',
  }

  postgresql::extension { 'enable-postgresql-extension-cube-for-database-vagrant':
    database  => 'vagrant',
    extension => 'cube',
  }

  postgresql::extension { 'enable-postgresql-extension-dict_xsyn-for-database-vagrant':
    database  => 'vagrant',
    extension => 'dict_xsyn',
  }

  postgresql::extension { 'enable-postgresql-extension-fuzzystrmatch-for-database-vagrant':
    database  => 'vagrant',
    extension => 'fuzzystrmatch',
  }

  postgresql::extension { 'enable-postgresql-extension-pg_trgm-for-database-vagrant':
    database  => 'vagrant',
    extension => 'pg_trgm',
  }

  postgresql::extension { 'enable-postgresql-extension-tablefunc-for-database-vagrant':
    database  => 'vagrant',
    extension => 'tablefunc',
  }
}

