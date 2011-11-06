class mqseries::keyman {
  include mqseries::runtime

  if ! defined(Package['libgcc']) { package { 'libgcc': ensure => present, } }
  if ! defined(Package['libstdc++']) { package { 'libstdc++': ensure => present, } }
  if ! defined(Package['compat-libstdc++-33']) { package { 'compat-libstdc++-33': ensure => present, } }

  package { 'gsk7bas':
    ensure => present,
    require => Package['MQSeriesRuntime', 'libgcc', 'libstdc++', 'compat-libstdc++-33'],
  }

  package { 'gsk7bas64':
    ensure => present,
    require => Package['MQSeriesRuntime', 'libgcc', 'libstdc++', 'compat-libstdc++-33'],
  }

  package { 'MQSeriesKeyMan':
    ensure => present,
    require => Package['MQSeriesRuntime', 'gsk7bas', 'gsk7bas64'],
  }
}

