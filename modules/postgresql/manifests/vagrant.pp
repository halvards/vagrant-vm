class postgresql::vagrant {
  include postgresql::server

  postgresql::role { 'create-postgresql-role-vagrant':
    role => 'vagrant',
  }

  postgresql::database { 'create-postgresql-database-vagrant':
    database => 'vagrant',
  }

  #exec { 'create-vagrant-postgres-role':
    #command => '/usr/bin/psql --command="create role "vagrant" with superuser createdb createrole login password \'vagrant\'"',
    #unless  => '/usr/bin/psql --command="\du" | /bin/grep vagrant',
    #user    => 'postgres',
    #require => [Service['postgresql'], User['postgres']],
  #}

  #exec { 'create-vagrant-database':
    #command => '/usr/bin/createdb vagrant',
    #unless  => '/usr/bin/psql --list | /bin/grep vagrant',
    #user    => 'postgres',
    #require => [Service['postgresql'], User['postgres']],
  #}
}

