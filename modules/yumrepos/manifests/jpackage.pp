class yumrepos::jpackage {
  package { 'jpackage-utils':
    ensure => present,
  }

  package { 'yum-priorities':
    ensure => present,
    name => $kernelrelease ? {
      /el5/ => 'yum-priorities',
      /el6/ => 'yum-plugin-priorities',
    },
  }

  package { 'jpackage-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/jpackage-release-6-2.jpp6.noarch.rpm',
    require => [Package['jpackage-utils'], Package['yum-priorities']],
  }
}

