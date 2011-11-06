class partition::swap2gb {
  exec { 'increase-swap':
    command => '/bin/bash /vagrant-share/conf/create-swap-file.sh',
    unless => "/bin/grep --quiet 'swapfile' /etc/fstab",
    logoutput => true,
  }
}

