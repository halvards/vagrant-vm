class editor::janus {
  include editor::x11
  include ruby::base
  include utils::base
  include utils::git

  $username = 'vagrant'

  package { 'ctags':
    ensure => present,
  }

  exec { 'install-vim-janus':
    command => "/usr/bin/sudo -u $username /bin/bash -c '/usr/bin/curl https://raw.github.com/carlhuda/janus/master/bootstrap.sh -o - | /bin/sh'",
    creates => "/home/$username/.vim/.git",
    require => Package['curl', 'git', 'rubygem-rake', 'vim-X11', 'ctags'],
  }
}

