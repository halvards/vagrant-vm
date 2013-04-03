class utils::mercurial {
  case $operatingsystem {
    'CentOS': {
      package { 'mercurial':
        ensure  => present,
      }
    }
    'Ubuntu': {
      include debrepos::mercurial

      package { 'mercurial':
        ensure  => present,
        require => Class['debrepos::mercurial'],
      }
    }
  }
}

