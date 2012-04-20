class rvm::user_install {
  include rvm::dependencies

  exec { 'user-rvm':
    command   => "/usr/bin/sudo -u vagrant /bin/bash -c '/bin/bash -s stable < <(/usr/bin/curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )'",
    creates => "/home/vagrant/.rvm",
    logoutput => true,
    require => Class['rvm::dependencies'],
  }

  line::present { 'load-user-rvm-in-vagrant-user-shell':
    file => '/home/vagrant/.bashrc',
    line => '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # loads RVM into the shell session',
  }
}

