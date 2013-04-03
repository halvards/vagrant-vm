class rvm::system_install {
  include rvm::dependencies
  include vagrant::user

  rvm::system_user { 'vagrant': }

  exec { 'system-rvm':
    command => '/usr/bin/curl -L https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer | /bin/bash -s stable',
    creates => '/usr/local/rvm/bin/rvm',
    require => Class['rvm::dependencies'],
  }

  line::present { 'load-system-rvm-in-vagrant-user-shell':
    file => '/home/vagrant/.bashrc',
    line => '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # loads RVM into the shell session',
  }
}

