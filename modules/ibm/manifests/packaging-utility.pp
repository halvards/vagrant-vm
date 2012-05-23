class ibm::packaging-utility {
  include ibm::pu-prereqs
  include utils::base
  include vagrant::user

  $ibm_pu_zip_location = '/vagrant-share/apps/IBMPU_linux_x86.zip'
  $ibm_pu_unzip_location = '/vagrant-share/apps/ibmrepos/pu'
  $ibm_pu_location = '/home/vagrant/IBM/PackagingUtility'

  wget::fetch { 'ibm-pu':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/pu/151/zips/pu.offering.disk.linux_1.5.1000.20111130_0726.zip',
    destination => $ibm_pu_zip_location,
  }

  exec { 'extract-ibm-pu-installer':
    command => "/usr/bin/unzip $ibm_pu_zip_location -d $ibm_pu_unzip_location",
    user    => 'vagrant',
    creates => "${ibm_pu_unzip_location}/InstallerImage_linux/userinstc",
    require => [Wget::Fetch['ibm-pu'], Package['unzip']],
  }

  exec { 'install-ibm-pu':
    command => "${ibm_pu_unzip_location}/InstallerImage_linux/userinstc -acceptLicense",
    user    => 'vagrant',
    creates => $ibm_pu_location,
    require => [Exec['extract-ibm-pu-installer'], Class['Ibm::Pu-prereqs']],
  }
}

class ibm::pu-prereqs {
  include apps::firefox

  # Packaging Utility command line (PUCL) prerequisites
  if ! defined(Package['compat-libstdc++-33'])        { package { 'compat-libstdc++-33':        ensure => present } }
  if ! defined(Package['compat-libstdc++-33.i686'])   { package { 'compat-libstdc++-33.i686':   ensure => present } }
  if ! defined(Package['elfutils'])                   { package { 'elfutils':                   ensure => present } }
  if ! defined(Package['elfutils-libs'])              { package { 'elfutils-libs':              ensure => present } }

  # Packaging Utility GUI prerequisites
  if ! defined(Package['gtk2.i686'])                  { package { 'gtk2.i686':                  ensure => present } }
  if ! defined(Package['gtk2-engines'])               { package { 'gtk2-engines':               ensure => present } }
  if ! defined(Package['libcanberra-gtk2.i686'])      { package { 'libcanberra-gtk2.i686':      ensure => present } }
  if ! defined(Package['PackageKit-gtk-module.i686']) { package { 'PackageKit-gtk-module.i686': ensure => present } }
}

