class openssl::ca {
  include openssl::base

  $username = 'vagrant'
  $ca_dir = "/home/${username}/CA"

  file { $ca_dir:
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => 700,
  }

  file { "${ca_dir}/newcerts":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => 700,
    require => File[$ca_dir],
  }

  file { "${ca_dir}/private":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => 700,
    require => File[$ca_dir],
  }

  exec { "create-ca-index.txt":
    command => "/usr/bin/touch ${ca_dir}/index.txt",
    creates => "${ca_dir}/index.txt",
    user    => $username,
    require => File[$ca_dir],
  }

  exec { "create-ca-serial-file":
    command => "/bin/echo '01' > ${ca_dir}/serial",
    creates => "${ca_dir}/serial",
    user    => $username,
    require => File[$ca_dir],
  }

  file { "/etc/ssl/openssl.cnf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => template('openssl/openssl.cnf.erb'),
    require => Class['openssl::base'],
  }

  exec { "create-ca-keypair-and-certificate":
    command   => "/usr/bin/openssl req -new -x509 -extensions v3_ca -nodes -out ${ca_dir}/cacert.pem -keyout ${ca_dir}/private/cakey.pem -days 3650 -subj \"/C=AU/ST=NSW/L=Sydney/O=Test CA/CN=Test CA\"",
    creates   => "${ca_dir}/private/cakey.pem",
    user      => $username,
    logoutput => true,
    require   => [Class['openssl::base'], File["${ca_dir}/private", "/etc/ssl/openssl.cnf"], Exec["create-ca-index.txt", "create-ca-serial-file"]],
  }
}

