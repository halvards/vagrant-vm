class yumrepos::google {
  yumrepo { 'google':
    descr => 'Google RPM Repository 64 bit',
    baseurl => 'http://dl.google.com/linux/rpm/stable/x86_64',
    enabled => 1,
    gpgcheck => 1,
    gpgkey => 'https://dl-ssl.google.com/linux/linux_signing_key.pub',
  }
}

