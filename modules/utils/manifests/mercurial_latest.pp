class utils::mercurial_latest {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::vagrantvms

      package { 'mercurial':
        ensure  => latest,
        require => Yumrepo['vagrantvms'],
      }
    }
    'Ubuntu': {
      package { 'mercurial':
        ensure  => present,
        require => Debrepos::Pparepo['mercurial-ppa/releases'],
      }
    }
  }
}

