class utils::rpm {
  include yumrepos::epel

  package { 'rpm-build':
    ensure => present,
  }

  package { 'rpmrebuild':
    ensure => present,
    require => Package['epel-release'],
  }
}

