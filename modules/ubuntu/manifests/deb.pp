class ubuntu::deb {
  if ! defined(Package['debconf-utils']) {
    package { 'debconf-utils':
      ensure => present,
    }
  }
}

