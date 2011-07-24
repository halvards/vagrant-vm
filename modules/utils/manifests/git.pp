class utils::git {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::rpmforge

      package { 'git':
        ensure => present,
        require => Package['rpmforge-release'],
      }
    }
    'Ubuntu': {
      package { 'git':
        ensure => present,
        name => 'git-core',
      }
    }
  }
}

