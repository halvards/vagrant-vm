class utils::mercurial {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::rpmforge

      package { 'mercurial':
        ensure => present,
        require => Package['rpmforge-release'],
      }
    }
    'Ubuntu': {
      package { 'mercurial':
        ensure => present,
      }
    }
  }
}

