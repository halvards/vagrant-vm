class apps::chrome {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::google

      package { 'google-chrome-stable':
        ensure  => present,
        require => Yumrepo['google'],
      }
    }
    'Ubuntu': {
      include debrepos::partner

      package { 'chromium-browser':
        ensure => present,
      }

      package { 'adobe-flashplugin':
        ensure  => present,
        require => Class['debrepos::partner'],
      }
    }
  }
}

