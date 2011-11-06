class utils::mercurial {
  case $operatingsystem {
    'CentOS': {
      package { 'mercurial':
        ensure => present,
      }
    }
    'Ubuntu': {
      package { 'mercurial':
        ensure => present,
      }
    }
  }
}

