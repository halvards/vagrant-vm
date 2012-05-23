class ubuntu::keybindings {
  include vagrant::user

  File {
    owner => 'vagrant',
    group => 'vagrant',
  }

  file {
    '/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0/options/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => "/vagrant-share/conf/ubuntu/keybindings/compiz-1/plugins/unityshell/screen0/options/${lsbdistcodename}-gconf.xml",
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0/options'];

    '/home/vagrant/.gconf/apps/gnome_settings_daemon/keybindings/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => "/vagrant-share/conf/ubuntu/keybindings/gnome_settings_daemon/keybindings/${lsbdistcodename}-gconf.xml",
      require => File['/home/vagrant/.gconf/apps/gnome_settings_daemon/keybindings'];

    '/home/vagrant/.gconf/apps/metacity/global_keybindings/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => "/vagrant-share/conf/ubuntu/keybindings/metacity/global_keybindings/${lsbdistcodename}-gconf.xml",
      require => File['/home/vagrant/.gconf/apps/metacity/global_keybindings'];

    '/home/vagrant/.gconf/apps/metacity/window_keybindings/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => "/vagrant-share/conf/ubuntu/keybindings/metacity/window_keybindings/${lsbdistcodename}-gconf.xml",
      require => File['/home/vagrant/.gconf/apps/metacity/window_keybindings'];
  }

  file {
    '/home/vagrant/.gconf/apps/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps'];

    '/home/vagrant/.gconf/apps/compiz-1/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps/compiz-1'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0'];

    '/home/vagrant/.gconf/apps/gnome_settings_daemon/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps/gnome_settings_daemon'];

    '/home/vagrant/.gconf/apps/metacity/%gconf.xml':
      ensure  => present,
      mode    => 600,
      source  => '/vagrant-share/conf/ubuntu/keybindings/empty-gconf.xml',
      require => File['/home/vagrant/.gconf/apps/metacity'];
  }

  file {
    '/home/vagrant/.gconf':
      ensure  => directory,
      mode    => 700,
      require => [User['vagrant'], Group['vagrant']];

    '/home/vagrant/.gconf/apps':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf'];

    '/home/vagrant/.gconf/apps/compiz-1':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/compiz-1'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell'];

    '/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0/options':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/compiz-1/plugins/unityshell/screen0'];

    '/home/vagrant/.gconf/apps/gnome_settings_daemon':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps'];

    '/home/vagrant/.gconf/apps/gnome_settings_daemon/keybindings':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/gnome_settings_daemon'];

    '/home/vagrant/.gconf/apps/metacity':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps'];

    '/home/vagrant/.gconf/apps/metacity/global_keybindings':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/metacity'];

    '/home/vagrant/.gconf/apps/metacity/window_keybindings':
      ensure  => directory,
      mode    => 700,
      require => File['/home/vagrant/.gconf/apps/metacity'];
  }
}

