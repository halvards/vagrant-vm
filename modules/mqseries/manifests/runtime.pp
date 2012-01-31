class mqseries::runtime {
  include mqseries::license
  include mqseries::users
  include yumrepos::vagrantvms

  if ! defined(Package['libXp.x86_64']) { package { 'libXp.x86_64': ensure => present, } }
  if ! defined(Package['glibc.i686'])   { package { 'glibc.i686':   ensure => present, } }

  package { 'MQSeriesRuntime':
    ensure => present,
    require => [File['/tmp/mq_license/license/status.dat'], Vagrant::Group['vagrant-mqm'], Package['glibc.i686', 'libXp.x86_64'], Yumrepo['vagrantvms']],
  }

  package { 'MQSeriesMan':
    ensure => present,
    require => Package['MQSeriesRuntime', 'man'],
  }
}

