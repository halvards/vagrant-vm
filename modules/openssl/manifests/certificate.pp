define openssl::certificate {
  include openssl::ca

  $hostname = $name
  $username = 'vagrant'
  $ssh_dir = "/home/${username}/.ssh"
  $ca_dir = "/home/${username}/CA"

  exec { "create-keypair-for-${hostname}":
    command   => "/usr/bin/openssl genrsa -out ${ssh_dir}/${hostname}.key 1024",
    creates   => "${ssh_dir}/${hostname}.key",
    user      => $username,
    cwd       => "/home/${username}",
    logoutput => true,
    require   => Class['openssl::base'],
  }

  exec { "create-certificate-signing-request-for-${hostname}":
    command   => "/usr/bin/openssl req -new -nodes -key ${ssh_dir}/${hostname}.key -out ${ssh_dir}/${hostname}.csr -days 3650 -subj \"/C=AU/ST=NSW/L=Sydney/O=Test CA/CN=localhost\"",
    creates   => "${ssh_dir}/${hostname}.csr",
    user      => $username,
    cwd       => "/home/${username}",
    logoutput => true,
    require   => Exec["create-keypair-for-${hostname}"],
  }

  exec { "sign-certificate-for-${hostname}-using-local-ca":
    command   => "/usr/bin/openssl ca -batch -out ${ssh_dir}/${hostname}.crt -in ${ssh_dir}/${hostname}.csr -days 3650",
    creates   => "${ssh_dir}/${hostname}.crt",
    user      => $username,
    cwd       => "/home/${username}",
    logoutput => true,
    require   => [Class['openssl::ca'], Exec["create-certificate-signing-request-for-${hostname}"]],
  }
}

