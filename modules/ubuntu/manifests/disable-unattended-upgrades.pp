# Ubuntu's unattended-upgrades appears to conflict with the VirtualBox Guest Extensions
class ubuntu::disable-unattended-upgrades {
  package { 'unattended-upgrades':
    ensure => present,
  }

  service { 'unattended-upgrades':
    enable     => false,
    ensure     => stopped,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['unattended-upgrades'],
  }
}

