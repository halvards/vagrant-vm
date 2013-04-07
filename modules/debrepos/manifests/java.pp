class debrepos::java {
  include ubuntu::deb

  debrepos::pparepo { 'webupd8team/java':
    apt_key => 'EEA14886',
    dist    => $lsbdistcodename,
  }

  exec { 'accept-oracle-java6-license':
    command => '/bin/echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
    unless  => '/usr/bin/debconf-get-selections | /bin/grep "oracle-java6-installer\s*shared/accepted-oracle-license-v1-1\s*select\s*true"',
    require => [Debrepos::Pparepo['webupd8team/java'], Package['debconf-utils']],
  }

  exec { 'accept-oracle-java7-license':
    command => '/bin/echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
    unless  => '/usr/bin/debconf-get-selections | /bin/grep "oracle-java7-installer\s*shared/accepted-oracle-license-v1-1\s*select\s*true"',
    require => [Debrepos::Pparepo['webupd8team/java'], Package['debconf-utils']],
  }

  exec { 'accept-oracle-java8-license':
    command => '/bin/echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
    unless  => '/usr/bin/debconf-get-selections | /bin/grep "oracle-java8-installer\s*shared/accepted-oracle-license-v1-1\s*select\s*true"',
    require => [Debrepos::Pparepo['webupd8team/java'], Package['debconf-utils']],
  }
}

