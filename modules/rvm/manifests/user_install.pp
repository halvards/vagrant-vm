class rvm::user_install($version='1.6.32') {
  include rvm::dependencies

  $username = 'vagrant'

  exec { 'user-rvm':
    command => "/usr/bin/sudo -u $username /bin/bash -c '/usr/bin/curl --silent https://rvm.beginrescueend.com/install/rvm --output /tmp/rvm-installer ; /bin/chmod +x /tmp/rvm-installer ; /tmp/rvm-installer --version ${version}'",
    creates => "/home/$username/.rvm",
    logoutput => true,
    require => Class['rvm::dependencies'],
  }
}

