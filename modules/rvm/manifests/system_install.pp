class rvm::system_install {
  include rvm::system
  include vagrant::user

  rvm::system_user { 'vagrant': }

  line::present { 'load-system-rvm-in-vagrant-user-shell':
    file => '/home/vagrant/.bashrc',
    line => '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # loads RVM into the shell session',
  }
}

