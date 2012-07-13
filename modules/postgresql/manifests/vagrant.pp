class postgresql::vagrant {
  include postgresql::server

  postgresql::role { 'create-postgresql-role-vagrant':
    role => 'vagrant',
  }

  postgresql::database { 'create-postgresql-database-vagrant':
    database => 'vagrant',
  }
}

