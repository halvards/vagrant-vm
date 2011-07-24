class selinux::disable {
  exec { 'disable-selinux':
    command => '/usr/sbin/setenforce 0',
  }
}

