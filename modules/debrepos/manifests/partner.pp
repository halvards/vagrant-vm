class debrepos::partner {
  line::uncomment { 'partner-repo':
    line => "deb.* http:\/\/archive\.canonical\.com\/ubuntu $lsbdistcodename partner",
    file => '/etc/apt/sources.list',
  }

  exec { 'update-apt-partner-repo':
    command => '/usr/bin/apt-get update && /usr/bin/touch /etc/apt/partner-repo.updated',
    creates => '/etc/apt/partner-repo.updated',
    timeout => 300, # seconds
    tries   => 3, # in case some ppa server is slow
    require => Line::Uncomment['partner-repo'],
  }
}

