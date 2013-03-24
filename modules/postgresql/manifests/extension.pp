define postgresql::extension($database, $extension) {
  exec { "enable-extension-${extension}-for-database-${database}":
    command   => "/usr/bin/psql ${database} -c 'CREATE EXTENSION ${extension}'",
    unless    => "/usr/bin/psql ${database} -c '\dx' | /bin/grep ' ${extension} '",
    user      => 'postgres',
    logoutput => true,
    require   => [Exec["create-${database}-database"], Package['postgresql-contrib']],
  }
}

