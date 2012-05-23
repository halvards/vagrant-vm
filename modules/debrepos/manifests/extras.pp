class debrepos::extras {
  line::uncomment { 'extras-repo':
    line => "deb.* http:\/\/extras\.ubuntu\.com\/ubuntu $lsbdistcodename main",
    file => '/etc/apt/sources.list',
  }

  exec { 'update-apt-extras-repo':
    command => '/usr/bin/apt-get update && /usr/bin/touch /etc/apt/extras-repo.updated',
    creates => '/etc/apt/extras-repo.updated',
    require => Line::Uncomment['extras-repo'],
  }
}

