class network::htracr {
  if ! defined(Package['g++'])         { package { 'g++':         ensure => present, } }
  if ! defined(Package['libpcap-dev']) { package { 'libpcap-dev': ensure => present, } }

  nodejs::npminstall { 'htracr':
    require => Package['g++', 'libpcap-dev'],
  }
}

