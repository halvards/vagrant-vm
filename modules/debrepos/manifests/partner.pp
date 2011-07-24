class debrepos::partner {
  uncomment { 'partner-repo':
    line => "deb.* http:\/\/archive.canonical.com\/ubuntu $lsbdistcodename partner",
    file => '/etc/apt/sources.list',
  }

  exec { 'update-apt':
    command => '/usr/bin/apt-get update',
    require => Uncomment['partner-repo'],
  }
}

define uncomment($line,$file) {
  exec { "sed-$name":
    command => "/bin/sed --regexp-extended --in-place 's/#+\s+($line.*)/\1/' $file",
    unless => "/bin/grep --extended-regexp '^$line' $file",
  }
}

