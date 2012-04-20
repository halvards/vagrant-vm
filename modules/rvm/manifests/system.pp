class rvm::system {
  include rvm::dependencies

  exec { 'system-rvm':
    command => "/bin/bash -c '/bin/bash -s stable < <(/usr/bin/curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )'",
    creates => '/usr/local/rvm/bin/rvm',
    require => Class['rvm::dependencies'],
  }
}

