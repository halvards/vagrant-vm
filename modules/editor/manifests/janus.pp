class editor::janus {
  include editor::vim
  include ruby::base
  include utils::base
  include vcs::git

  $username = 'vagrant'

  if ! defined(Package['ctags']) {
    package { 'ctags':
      ensure => present,
    }
  }

  exec { 'install-vim-janus':
    command => "/usr/bin/sudo -u $username /bin/bash -c '/usr/bin/curl -Lo- https://bit.ly/janus-bootstrap | /bin/bash'",
    creates => "/home/$username/.vim/.git",
    timeout => 600, # seconds
    require => [Package['curl', 'git', 'vim', 'ctags'], Class['ruby::base']],
  }
}

