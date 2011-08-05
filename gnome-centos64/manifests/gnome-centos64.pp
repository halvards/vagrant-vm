include timezone::sydney
include utils::base
include wm::gnome
include google::chrome

class wm::gnome {
  package { ['gnome-session', 'xorg-x11-xinit', 'gdm', 'dbus-x11', 'gnome-applets', 'gnome-terminal', 'nautilus', 'gedit']:
    ensure => present,
  }

  package { 'xresolution':
    ensure => present,
    name => $kernelrelease ? {
      /el5/ => 'system-config-display',
      /el6/ => 'libXrandr.x86_64'
    },
  }
}

