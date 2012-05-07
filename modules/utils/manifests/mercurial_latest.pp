class utils::mercurial_latest {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::vagrantvms
      package { 'mercurial':
        ensure => latest,
        require => Yumrepo['vagrantvms'],
      }
    }
    'Ubuntu': {
      debrepos::pparepo { 'mercurial-ppa/releases':
        apt_key => '323293EE',
        dist => $lsbdistcodename,
        require => Debrepos::Pparepo['mercurial-ppa/builddeps'],
      }
      debrepos::pparepo { 'mercurial-ppa/builddeps':
        apt_key => '323293EE',
        dist => $lsbdistcodename,
      }
      exec { 'update-apt-for-mercurial':
        command => '/usr/bin/apt-get update',
        require => Debrepos::Pparepo['mercurial-ppa/releases'],
      }
      package { 'mercurial':
        ensure => present,
        require => Exec['update-apt-for-mercurial'],
      }
    }
  }
}

