define nodejs::npminstall($version = '') {
  include nodejs::base

  exec { "install-npm-module-${name}":
    command   => "/usr/bin/npm install --silent --global ${name}@${version}",
    unless    => "/usr/bin/npm list --global | /bin/grep --quiet '${name}@${version}'",
    timeout   => 60, # some packages need to compile C code
    logoutput => true,
    require   => Class['nodejs::base'],
  }
}

