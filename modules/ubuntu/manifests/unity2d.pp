class ubuntu::unity2d {
  include ubuntu::updateapt

  package { ['unity-2d', 'xorg', 'gnome-terminal', 'python-aptdaemon.gtkwidgets', 'network-manager-gnome', 'lightdm', 'ubuntu-artwork', 'ubuntu-extras-keyring', 'ca-certificates', 'notify-osd', 'libnotify-bin', 'ttf-dejavu-core', 'ttf-freefont', 'x-ttcidfont-conf', 'ttf-liberation', 'ttf-ubuntu-font-family']:
    ensure  => present,
    require => Class['ubuntu::updateapt'],
  }
}

