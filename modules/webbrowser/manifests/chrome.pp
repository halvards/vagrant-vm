class webbrowser::chrome {
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

  $username = 'vagrant'

  file { "/home/${username}/.config":
    ensure => directory,
    owner  => $username,
    group  => $username,
    mode   => 755,
  }

  file { "/home/${username}/.config/chromium":
    ensure  => directory,
    owner  => $username,
    group  => $username,
    mode   => 755,
    require => File["/home/${username}/.config"],
  }

  file { "/home/${username}/.config/chromium/Default":
    ensure  => directory,
    owner  => $username,
    group  => $username,
    mode   => 755,
    require => File["/home/${username}/.config/chromium"],
  }

  file { "/home/${username}/.config/chromium/Default/Extensions":
    ensure  => directory,
    owner  => $username,
    group  => $username,
    mode   => 755,
    require => File["/home/${username}/.config/chromium/Default"],
  }
}

