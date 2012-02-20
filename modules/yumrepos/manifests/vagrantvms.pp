class yumrepos::vagrantvms {
  yumrepo { 'vagrantvms-common':
    descr    => 'RPM Repository for Vagrant VMs Common',
    baseurl  => 'http://dl.dropbox.com/u/41147122/rpmrepo/common/',
    enabled  => 1,
    gpgcheck => 0,
  }

  yumrepo { 'vagrantvms':
    descr    => 'RPM Repository for Vagrant VMs Release Specific',
    baseurl  => $kernelrelease ? {
      /el5/ => 'http://dl.dropbox.com/u/41147122/rpmrepo/5/',
      /el6/ => 'http://dl.dropbox.com/u/41147122/rpmrepo/6/',
    }
    enabled  => 1,
    gpgcheck => 0,
  }
}

