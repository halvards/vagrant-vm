class google::chrome {
  include yumrepos::google

  package { 'google-chrome-stable':
    ensure => present,
    require => Yumrepo['google'],
  }
}

