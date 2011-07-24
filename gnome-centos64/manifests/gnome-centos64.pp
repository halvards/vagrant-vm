include timezone::sydney
include utils::base
include wm::gnome

class wm::gnome {
  package { ['gnome-session', 'system-config-display', 'xorg-x11-xinit', 'gdm', 'dbus-x11', 'gnome-applets', 'gnome-terminal', 'nautilus', 'gedit', 'firefox.x86_64']:
    ensure => present,
  }
}

