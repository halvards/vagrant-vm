class rvm::system($version='1.6.32') {
  include rvm::dependencies

  exec { 'system-rvm':
    command => "/bin/bash -c '/usr/bin/curl --silent https://rvm.beginrescueend.com/install/rvm --output /tmp/rvm-installer ; /bin/chmod +x /tmp/rvm-installer ; rvm_bin_path=/usr/local/rvm/bin rvm_man_path=/usr/local/rvm/man /tmp/rvm-installer --version ${version}'",
    creates => '/usr/local/rvm/bin/rvm',
    require => Class['rvm::dependencies'],
  }
}

