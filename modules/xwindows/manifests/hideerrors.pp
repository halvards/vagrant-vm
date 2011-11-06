class xwindows::hideerrors {
  # This file can fill up with garbage and grow uncontrollably if some GTK themes are missing
  file { '/home/vagrant/.xsession-errors':
    ensure => link,
    group => 'vagrant',
    owner => 'vagrant',
    target => '/dev/null',
  }

  file { '/home/vagrant/.xsession-errors.old':
    ensure => link,
    group => 'vagrant',
    owner => 'vagrant',
    target => '/dev/null',
  }
}

