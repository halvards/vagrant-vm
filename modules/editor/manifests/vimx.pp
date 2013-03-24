class editor::vimx {
  include editor::vim

  package { 'vim-X11':
    ensure  => present,
    depends => Package['vim'];
  }
}

