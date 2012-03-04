class google::chrome {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::google

      package { 'google-chrome-stable':
        ensure => present,
        require => Yumrepo['google'],
      }
    }
    'Ubuntu': {
      package { 'chromium-browser':
        ensure => present,
      }
    }
  }
}

