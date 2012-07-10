define postgresql::database($database) {
  exec { "create-${database}-database":
    command => "/usr/bin/createdb ${database}",
    unless  => "/usr/bin/psql --list | /bin/grep ${database}",
    user    => 'postgres',
    require => [Service['postgresql'], User['postgres']],
  }
}

