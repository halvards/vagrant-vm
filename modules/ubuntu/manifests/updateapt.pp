class ubuntu::updateapt {
  # necessary since some mirrors change their layout
  exec { 'update-apt-on-first-boot':
    command => '/usr/bin/apt-get update && /usr/bin/touch /root/.first-boot-apt-update',
    creates => '/root/.first-boot-apt-update',
    timeout => 300, # seconds
    tries   => 3, # in case a repo is slow
  }
}

