# Prerequisites for IBM Installation Manager
class ibm::im-prereqs {
  include apps::firefox
  include iptables::disable
  include selinux::disable
  include utils::base

  $ibm_im_zip_location = '/vagrant-share/apps/IBMIM_linux_x86.zip'
  $ibm_im_extract_location = '/vagrant-share/apps/ibmrepos/im'

  wget::fetch { 'ibm-im':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/151/zips/agent.installer.linux.gtk.x86_1.5.1000.20111128_0824.zip',
    destination => $ibm_im_zip_location,
  }

  exec { 'extract-ibm-im-installer':
    command => "/usr/bin/unzip $ibm_im_zip_location -d $ibm_im_extract_location",
    creates => "$ibm_im_extract_location/install",
    require => [Wget::Fetch['ibm-im'], Package['unzip']],
  }

  # Installation Manager command line (imcl) prerequisites
  if ! defined(Package['compat-libstdc++-33'])        { package { 'compat-libstdc++-33':        ensure => present } }
  if ! defined(Package['compat-libstdc++-33.i686'])   { package { 'compat-libstdc++-33.i686':   ensure => present } }
  if ! defined(Package['elfutils'])                   { package { 'elfutils':                   ensure => present } }
  if ! defined(Package['elfutils-libs'])              { package { 'elfutils-libs':              ensure => present } }

  # Installation Manager GUI prerequisites
  if ! defined(Package['gtk2.i686'])                  { package { 'gtk2.i686':                  ensure => present } }
  if ! defined(Package['gtk2-engines.i686'])          { package { 'gtk2-engines.i686':          ensure => present } }
  if ! defined(Package['libcanberra-gtk2.i686'])      { package { 'libcanberra-gtk2.i686':      ensure => present } }
  if ! defined(Package['libXtst.i686'])               { package { 'libXtst.i686':               ensure => present } }
  if ! defined(Package['PackageKit-gtk-module.i686']) { package { 'PackageKit-gtk-module.i686': ensure => present } }

  # Other prerequisites that may not be needed, they were left over from older recipes
  if ! defined(Package['glibc'])                      { package { 'glibc':                      ensure => present } }
  if ! defined(Package['glibc.i686'])                 { package { 'glibc.i686':                 ensure => present } }
  if ! defined(Package['libstdc++'])                  { package { 'libstdc++':                  ensure => present } }
}

