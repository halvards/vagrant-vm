class nodejs::nvm {
  include utils::base
  include vagrant::user

  $username = 'vagrant'

  exec { 'install-nvm':
    command     => '/usr/bin/curl https://raw.github.com/creationix/nvm/master/install.sh | /bin/sh',
    cwd         => "/home/${username}",
    creates     => "/home/${username}/.nvm/.git",
    user        => $username,
    logoutput   => true,
    require     => [Package['curl'], User["${username}"]],
    environment => [ "HOME=/home/${username}" ],
  }
 
}

