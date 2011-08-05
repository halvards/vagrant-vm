class google::chrome {
  include yumrepos::google

  package { 'google-chrome-stable':
    ensure => present,
    requires => Yumrepo['google'],
  }
}

