# Air for Linux is discontinued, version 2.6 is the latest version supported by Adobe
# Installation requires an X server so this recipe uses xvfb
class apps::adobeair {
  include apps::xvfb
  include utils::getlibs

  if ! defined(Package['ia32-libs'])         { package { 'ia32-libs':         ensure => present } }
  if ! defined(Package['lib32nss-mdns'])     { package { 'lib32nss-mdns':     ensure => present } }
  if ! defined(Package['libgnome-keyring0']) { package { 'libgnome-keyring0': ensure => present } }
  if ! defined(Package['libhal-storage1'])   { package { 'libhal-storage1':   ensure => present } }

  exec { 'install-libhal-storage-32-bit':
    command => '/usr/bin/getlibs -y -l libhal-storage.so.1',
    creates => '/usr/lib32/libhal-storage.so.1',
    logoutput => true,
    require => Package['getlibs', 'libhal-storage1'],
  }

  exec { 'install-libgnome-keyring-32-bit':
    command => '/usr/bin/getlibs -y -l libgnome-keyring.so.0',
    creates => '/usr/lib32/i386-linux-gnu/libgnome-keyring.so.0',
    logoutput => true,
    require => Package['getlibs', 'libgnome-keyring0'],
  }

  file { '/usr/lib/libgnome-keyring.so.0':
    ensure  => link,
    target  => '/usr/lib/i386-linux-gnu/libgnome-keyring.so.0',
    require => Exec['install-libgnome-keyring-32-bit'],
  }

  wget::fetch { 'adobeair-installer':
    source      => 'http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRInstaller.bin',
    destination => '/vagrant-share/apps/AdobeAIRInstaller.bin',
  }

  exec { 'make-adobeair-installer-executable':
    command => '/bin/chmod +x /vagrant-share/apps/AdobeAIRInstaller.bin',
    require => Wget::Fetch['adobeair-installer'],
  }

  exec { 'install-adobe-air':
    command   => "/usr/bin/xvfb-run /vagrant-share/apps/AdobeAIRInstaller.bin -silent",
    creates   => "/opt/Adobe\ AIR/Versions/1.0/Adobe\ AIR\ Application\ Installer",
    logoutput => true,
    require   => [Package['xvfb', 'ia32-libs', 'lib32nss-mdns'], Exec['make-adobeair-installer-executable', 'install-libhal-storage-32-bit'], File['/usr/lib/libgnome-keyring.so.0']],
  }
}

