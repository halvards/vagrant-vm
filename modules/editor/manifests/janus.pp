class editor::janus {
  include editor::vim
  include ruby::base
  include utils::base
  include utils::git

  $username = 'vagrant'

  package { 'ctags':
    ensure => present,
  }

  exec { 'install-vim-janus':
    command => "/usr/bin/sudo -u $username /bin/bash -c '/usr/bin/curl -Lo- https://bit.ly/janus-bootstrap | /bin/bash'",
    creates => "/home/$username/.vim/.git",
    require => [Package['curl', 'git', 'vim', 'ctags'], Class['ruby::base']],
  }
}

