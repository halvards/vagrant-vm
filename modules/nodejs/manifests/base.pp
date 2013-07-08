class nodejs::base {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::epel

      package{ ['nodejs', 'npm']:
        ensure  => present,
        require => Package['epel-release'],
      }
    }
    'Ubuntu': {
      include debrepos::nodejs

      package { 'nodejs':
        ensure  => present,
        require => Class['debrepos::nodejs'],
      }
    }
  }
}

