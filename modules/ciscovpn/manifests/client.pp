class ciscovpn::client {
  exec { 'install-anyconnect':
    command => '/bin/bash /vagrant-share/conf/vpnsetup.sh',
    creates => '/opt/cisco/vpn/bin/vpn',
    logoutput => true,
  }
}

