class utils::rpm {
  include yumrepos::epel

  package { ['rpm-build', 'createrepo']:
    ensure => present,
  }

  package { 'rpmrebuild':
    ensure  => present,
    require => Package['epel-release'],
  }
}

