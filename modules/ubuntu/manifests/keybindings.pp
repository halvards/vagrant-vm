class ubuntu::keybindings {
  include vagrant::user

  file { '/home/vagrant/.gconf/apps/metacity/global_keybindings/%gconf.xml':
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 600,
    source  => '/vagrant-share/conf/ubuntu/keybindings/metacity_global_gconf.xml',
    require => [User['vagrant'], Group['vagrant']],
  }

  file { '/home/vagrant/.gconf/apps/metacity/window_keybindings/%gconf.xml':
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => 600,
    source  => '/vagrant-share/conf/ubuntu/keybindings/metacity_window_gconf.xml',
    require => [User['vagrant'], Group['vagrant']],
  }

  file { '/home/vagrant/.gconf/apps/gnome_settings_daemon/keybindings/%gconf.xml':
    ensure => present,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 600,
    source => '/vagrant-share/conf/ubuntu/keybindings/gnome_gconf.xml',
    require => [User['vagrant'], Group['vagrant']],
  }
}

