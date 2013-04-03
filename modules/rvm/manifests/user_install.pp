class rvm::user_install {
  include rvm::dependencies
  include vagrant::user

  $username = 'vagrant'

  exec { 'user-rvm':
    command   => '/usr/bin/curl -L https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer | /bin/bash -s stable',
    creates   => "/home/${username}/.rvm",
    user      => $username,
    logoutput => true,
    require   => [Class['rvm::dependencies'], User["${username}"]],
    environment => [ "HOME=/home/${username}" ],
  }

  line::present { 'load-user-rvm-in-vagrant-user-shell':
    file => '/home/vagrant/.bashrc',
    line => '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # loads RVM into the shell session',
  }
}

