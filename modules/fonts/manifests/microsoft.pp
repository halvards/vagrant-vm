class fonts::microsoft {
  package { 'debconf-utils':
    ensure => present,
  }

  exec { 'accept-msttcorefonts-license':
    command => '/bin/sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"',
    unless  => '/usr/bin/debconf-get-selections | /bin/grep "ttf-mscorefonts-installer\s*msttcorefonts/accepted-mscorefonts-eula\s*select\s*true"',
    require => Package['debconf-utils'],
  }

  package { 'ttf-mscorefonts-installer':
    ensure  => present,
    require => Exec['accept-msttcorefonts-license'],
  }
}

