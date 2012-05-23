# Adding Wine downloads approximately 450 MB worth of packages
class apps::wine {
  include utils::getlibs

  debrepos::pparepo { 'ubuntu-wine/ppa':
    apt_key => 'F9CB8DB0',
  }

  package { 'wine':
    ensure  => present,
    require => Debrepos::Pparepo['ubuntu-wine/ppa'],
  }

  exec { 'install-gnome-keyring-i386':
    command => '/usr/bin/getlibs -y -p gnome-keyring:i386',
    creates => '/usr/lib32/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so',
    logoutput => true,
    require => Package['getlibs'],
  }

  # These manifests prevent Kindle Reader for PC from launching. I don't
  # know what they are meant to do and the consequences of removing them
  exec { 'remove-troublesome-manifests':
    command => '/bin/rm /home/vagrant/.wine/drive_c/windows/winsxs/manifests/*deadbeef.manifest',
    onlyif  => '/bin/ls /home/vagrant/.wine/drive_c/windows/winsxs/manifests/*deadbeef.manifest 2> /dev/null',
  }

  file { '/usr/lib/i386-linux-gnu':
    ensure  => directory,
  }

  file { '/usr/lib/i386-linux-gnu/pkcs11':
    ensure  => directory,
    require => File['/usr/lib/i386-linux-gnu'],
  }

  file { '/usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so':
    ensure  => link,
    target  => '/usr/lib32/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so',
    require => [Exec['install-gnome-keyring-i386'], File['/usr/lib/i386-linux-gnu/pkcs11']],
  }
}

