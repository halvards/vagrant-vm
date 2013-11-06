class ubuntu::updateapt {
  $ubuntu_mirror = 'http:\/\/mirror\.aarnet\.edu\.au\/pub\/ubuntu\/'
  $default_ubuntu_mirror = 'http:\/\/us\.archive\.ubuntu\.com\/ubuntu\/'

  exec { 'set-ubuntu-mirror':
    command => "/bin/sed -i 's/$default_ubuntu_mirror/$ubuntu_mirror/g' /etc/apt/sources.list",
    unless  => "/bin/grep --quiet '$ubuntu_mirror' /etc/apt/sources.list"
  }

  # necessary since some mirrors change their layout
  exec { 'update-apt-on-first-boot':
    command => '/usr/bin/apt-get update && /usr/bin/touch /root/.first-boot-apt-update',
    creates => '/root/.first-boot-apt-update',
    timeout => 300, # seconds
    tries   => 3, # in case a repo is slow
    require => Exec['set-ubuntu-mirror'],
  }
}

