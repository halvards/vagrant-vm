class mqseries::explorer {
  include mqseries::runtime
  include vagrant::user

  # MQ Explorer requires some 32 bit libraries
  if ! defined(Package['gtk2.i686'])                  { package { 'gtk2.i686':                  ensure => present, } }
  if ! defined(Package['gtk2-engines.i686'])          { package { 'gtk2-engines.i686':          ensure => present, } }
  if ! defined(Package['libcanberra.i686'])           { package { 'libcanberra.i686':           ensure => present, } }
  if ! defined(Package['libcanberra-gtk2.i686'])      { package { 'libcanberra-gtk2.i686':      ensure => present, } }
  if ! defined(Package['PackageKit-gtk-module.i686']) { package { 'PackageKit-gtk-module.i686': ensure => present, } }

  package { ['MQSeriesEclipseSDK33', 'MQSeriesConfig', 'MQSeriesJava']:
    ensure => present,
    require => Package['MQSeriesRuntime', 'gtk2.i686', 'libcanberra.i686', 'gtk2-engines.i686', 'PackageKit-gtk-module.i686'],
  }

  exec { 'setup-mqexplorer-lib':
    command => "/bin/echo 'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/opt/mqm/java/lib' >> /home/vagrant/.bashrc",
    unless => "/bin/grep --quiet '/opt/mqm/java/lib' /home/vagrant/.bashrc",
  }

  file { '/home/vagrant/Desktop/MQExplorer.desktop':
    ensure => present,
    mode => 775,
    owner => 'vagrant',
    group => 'vagrant',
    source => '/vagrant-share/conf/MQExplorer.desktop',
    require => [Package['MQSeriesEclipseSDK33', 'MQSeriesConfig', 'MQSeriesJava'], User['vagrant'], Group['vagrant']],
  }
}

