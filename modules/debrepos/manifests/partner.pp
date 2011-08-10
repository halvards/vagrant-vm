class debrepos::partner {
  line::uncomment { 'partner-repo':
    line => "deb.* http:\/\/archive.canonical.com\/ubuntu $lsbdistcodename partner",
    file => '/etc/apt/sources.list',
  }

  exec { 'update-apt':
    command => '/usr/bin/apt-get update',
    require => Line::Uncomment['partner-repo'],
  }
}

