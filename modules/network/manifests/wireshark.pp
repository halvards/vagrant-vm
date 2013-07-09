class network::wireshark {
  package { 'wireshark':
    ensure => present,
  }

  exec { 'wireshark-dpkg-allow-non-root-users-to-listen':
    command => '/bin/echo "wireshark-common wireshark-common/install-setuid boolean true" | /usr/bin/debconf-set-selections',
    unless  => '/usr/bin/debconf-get-selections | /bin/grep "wireshark-common\s*wireshark-common/install-setuid\s*boolean\s*true"',
    require => Package['wireshark'],
  }

  group { 'wireshark':
    ensure => present,
  }

  vagrant::group { 'vagrant-wireshark':
    group   => 'wireshark',
    require => Group['wireshark'],
  }

  file { '/usr/bin/dumpcap':
    owner   => 'root',
    group   => 'wireshark',
    mode    => 754,
    require => [Package['wireshark'], Group['wireshark']],
  }

  exec { 'set-dumpcap-capabilities-for-non-root-users':
    command => "/sbin/setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap",
    unless  => "/sbin/getcap /usr/bin/dumpcap | /bin/grep --quiet cap_net_raw",
    require => Package['wireshark'],
  }

  file { '/home/vagrant/.wireshark':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 755,
  }

  $ports = [ '443', '8443', '9443' ]
  file { '/home/vagrant/.wireshark/ssl_keys':
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 664,
    content => template('network/wireshark_ssl_keys.erb'),
    require => File['/home/vagrant/.wireshark'],
  }
}

