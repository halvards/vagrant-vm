class yumrepos::remi {
  include yumrepos::epel

  yumrepo { 'remi':
    descr      => 'REMI repository',
    #baseurl   => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/$basearch/',
    mirrorlist => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror',
    enabled    => 1,
    gpgcheck   => 0,
    require => Package['epel-release'],
  }
}

