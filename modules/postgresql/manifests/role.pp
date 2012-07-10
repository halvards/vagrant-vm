define postgresql::role($role) {
  exec { "create-${role}-postgres-role":
    command => "/usr/bin/psql --command=\"create role \"${role}\" with superuser createdb createrole login password '${role}'\"",
    unless  => "/usr/bin/psql --command=\"\\du\" | /bin/grep ${role}",
    user    => 'postgres',
    require => [Service['postgresql'], User['postgres']],
  }
}

