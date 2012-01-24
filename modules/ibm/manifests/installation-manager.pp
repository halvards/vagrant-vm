class ibm::installation-manager {
  include ibm::im-prereqs
  include iptables::disable
  include selinux::disable
  include utils::base
  include vagrant::user

  $ibm_im_zip_location = '/vagrant-share/apps/IBMIM_linux_x86.zip'
  $ibm_im_location = '/home/vagrant/IBM/InstallationManager'

  wget::fetch { 'ibm-im':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/151/zips/agent.installer.linux.gtk.x86_1.5.1000.20111128_0824.zip',
    destination => $ibm_im_zip_location,
  }

  exec { 'extract-ibm-im-installer':
    command => "/usr/bin/unzip $ibm_im_zip_location -d /tmp/ibmim/",
    user    => 'vagrant',
    creates => '/tmp/ibmim/userinstc',
    unless  => "/bin/ls /tmp/ibmim/already_installed | /bin/grep already_installed",
    require => [Wget::Fetch['ibm-im'], Package['unzip']],
  }

  exec { 'install-ibm-im':
    command => '/tmp/ibmim/userinstc -acceptLicense',
    user    => 'vagrant',
    creates => $ibm_im_location,
    unless  => "/bin/ls /tmp/ibmim/already_installed | /bin/grep already_installed",
    require => [Exec['extract-ibm-im-installer'], Class['Ibm::Im-prereqs', 'Iptables::Disable', 'Selinux::Disable']],
  }
}

class ibm::im-prereqs {
  include mozilla::firefox

  # Installation Manager command line (imcl) prerequisites
  if ! defined(Package['compat-libstdc++-33'])        { package { 'compat-libstdc++-33':        ensure => present } }
  if ! defined(Package['compat-libstdc++-33.i686'])   { package { 'compat-libstdc++-33.i686':   ensure => present } }
  if ! defined(Package['elfutils'])                   { package { 'elfutils':                   ensure => present } }
  if ! defined(Package['elfutils-libs'])              { package { 'elfutils-libs':              ensure => present } }

  # Installation Manager GUI prerequisites
  # Error message: gtk2-engines-2.18.4-5.el6.centos.i686 is a duplicate with gtk2-engines-2.18.4-5.el6.x86_64
  if ! defined(Package['gtk2.i686'])                  { package { 'gtk2.i686':                  ensure => present } }
  if ! defined(Package['gtk2-engines'])               { package { 'gtk2-engines':               ensure => present } }
  if ! defined(Package['gtk2-engines.i686'])          { package { 'gtk2-engines.i686':          ensure => present } }
  if ! defined(Package['libcanberra-gtk2.i686'])      { package { 'libcanberra-gtk2.i686':      ensure => present } }
  if ! defined(Package['PackageKit-gtk-module.i686']) { package { 'PackageKit-gtk-module.i686': ensure => present } }

  # Other prerequisites that may not be needed, they were left over from older recipes
  # Error message: libstdc++-4.4.6-3.el6.i686 is a duplicate with libstdc++-4.4.4-13.el6.x86_64
  if ! defined(Package['glibc'])                      { package { 'glibc':                      ensure => present } }
  if ! defined(Package['glibc.i686'])                 { package { 'glibc.i686':                 ensure => present } }
  if ! defined(Package['libstdc++'])                  { package { 'libstdc++':                  ensure => present } }
  #if ! defined(Package['libstdc++.i686'])             { package { 'libstdc++.i686':             ensure => present } }
}

