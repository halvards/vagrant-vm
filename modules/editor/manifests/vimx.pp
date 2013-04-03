class editor::vimx {
  include editor::vim

  package { 'vimx':
    name => $operatingsystem ? {
      'CentOS' => 'vim-X11',
      'Ubuntu' => 'vim-gnome',
    },
    ensure  => present,
    require => Package['vim'];
  }
}

