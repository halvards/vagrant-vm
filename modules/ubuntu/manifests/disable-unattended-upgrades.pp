# Ubuntu's unattended-upgrades appears to conflict with the VirtualBox Guest Extensions
class ubuntu::disable-unattended-upgrades {
  package { 'unattended-upgrades':
    ensure => absent,
  }
}

