class gnome::removeapplets {
  package { 'gnome-packagekit':
    ensure => absent,
  }
}

