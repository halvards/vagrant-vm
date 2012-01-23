class selinux::disable {
  exec { 'disable-selinux':
    command => '/usr/sbin/setenforce 0',
    onlyif  => "/usr/sbin/getenforce | /bin/grep 'Enforcing'",
  }
}

