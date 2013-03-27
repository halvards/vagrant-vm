class virtualbox::guestadditions {

  $guestadditions_version = '4.2.10'

  $guestadditions_iso_filename = "VBoxGuestAdditions_${guestadditions_version}.iso"
  $guestadditions_iso_location = "/vagrant-share/apps/${guestadditions_iso_filename}"
  $guestadditions_mount_directory = "/media/cdrom"
  $guestadditions_installation_directory = "/opt/VBoxGuestAdditions-${guestadditions_version}"

  exec { 'install-kernel-headers':
    command => '/usr/bin/apt-get install -y linux-headers-$(uname -r) build-essential',
    unless  => '/usr/bin/dpkg --get-selections | grep linux-headers-$(uname -r)',
  }

  if ! defined(Package['dkms']) { 
    package { 'dkms':
      ensure  => present,
      require => Exec['install-kernel-headers'],
    }
  }

  wget::fetch { 'guestadditions':
    source      => "http://download.virtualbox.org/virtualbox/${guestadditions_version}/VBoxGuestAdditions_${guestadditions_version}.iso",
    destination => $guestadditions_iso_location,
  }

  exec { 'mount-guestadditions-iso':
    command => "/bin/umount ${guestadditions_mount_directory} ; /bin/mount ${guestadditions_iso_location} ${guestadditions_mount_directory}",
    creates => $guestadditions_installation_directory,
    require => Wget::Fetch['guestadditions'],
    notify  => Exec['install-guestadditions'],
  }

  exec { 'install-guestadditions':
    command   => "/bin/sh ${guestadditions_mount_directory}/VBoxLinuxAdditions.run",
    creates   => $guestadditions_installation_directory,
    logoutput => true,
    require   => [Wget::Fetch['guestadditions'], Package['dkms']],
    notify    => Exec['unmount-guestadditions-iso'],
  }

  exec { 'unmount-guestadditions-iso':
    command => "/bin/umount ${guestadditions_mount_directory}",
    creates => $guestadditions_installation_directory,
    require => Exec['install-guestadditions'],
  }
}

