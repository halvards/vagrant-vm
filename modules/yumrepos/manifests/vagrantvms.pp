class yumrepos::vagrantvms {
  yumrepo { 'vagrantvms':
    descr    => 'RPM Repository for Vagrant VMs',
    baseurl  => 'http://dl.dropbox.com/u/41147122/rpmrepo/',
    enabled  => 1,
    gpgcheck => 0,
  }
}

