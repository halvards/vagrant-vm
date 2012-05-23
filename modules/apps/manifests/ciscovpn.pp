class apps::ciscovpn {
  wget::fetch { 'anyconnect-client':
    source      => 'http://dl.dropbox.com/u/41147122/apps/vpnsetup.sh',
    destination => '/vagrant-share/apps/vpnsetup.sh',
  }

  exec { 'install-anyconnect':
    command   => '/bin/bash /vagrant-share/apps/vpnsetup.sh',
    creates   => '/opt/cisco/vpn/bin/vpn',
    logoutput => true,
    require   => Wget::Fetch['anyconnect-client'],
  }
}

