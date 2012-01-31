# IBM WebSphere Integration Developer
class ibm::wid {
  include ibm::wid-prereqs
  include ibm::im-user

  $ibm_location = '/home/vagrant/IBM'

  exec { 'install-ibm-wid':
    command   => "${ibm_location}/InstallationManager/eclipse/tools/imcl -input /vagrant-share/ibmwid-response.xml -acceptLicense -showProgress",
    user      => 'vagrant',
    creates   => "${ibm_location}/WID7",
    timeout   => 3600, #seconds
    logoutput => true,
    require   => [Exec['install-ibm-im'], Class['Ibm::Wid-prereqs']],
  }

  # Use response file ibmwps-response.xml for WebSphere Process Server and WebSphere ESB only
  # Use response file ibmwpsbm-response.xml instead to also install Business Monitor
  exec { 'install-ibm-wps':
    command   => "${ibm_location}/InstallationManager/eclipse/tools/imcl -input /vagrant-share/ibmwps-response.xml -acceptLicense -showProgress",
    user      => 'vagrant',
    creates   => "${ibm_location}/WID7_WTE/runtimes/bi_v7",
    timeout   => 10800, #seconds
    logoutput => true,
    require   => Exec['install-ibm-wid'],
  }
}

class ibm::wid-prereqs {
  include partition::swap2gb

  $open_files_config_file = '/etc/security/limits.conf'

  # Increase file handle limit, see page 41 of http://publib.boulder.ibm.com/infocenter/dmndhelp/v7r0mx/topic/com.ibm.wbit.help.inst.doc/wbit_inst_pdf.pdf
  file { $open_files_config_file:
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '644',
  }

  line::present { 'increase-hard-open-files-limit':
    file => $open_files_config_file,
    line => '* hard nofile 8096',
    require => File[$open_files_config_file],
  }

  line::present { 'increase-soft-open-files-limit':
    file => $open_files_config_file,
    line => '* soft nofile 4096',
    require => File[$open_files_config_file],
  }

  # http://publib.boulder.ibm.com/infocenter/wasinfo/v7r0/index.jsp?topic=%2Fcom.ibm.websphere.installation.base.doc%2Finfo%2Faes%2Fae%2Ftins_linuxsetup_rhel6.html
  if ! defined(Package['libXp'])                      { package { 'libXp':                      ensure => present } }
  if ! defined(Package['libXp.i686'])                 { package { 'libXp.i686':                 ensure => present } }
  if ! defined(Package['libXmu'])                     { package { 'libXmu':                     ensure => present } }
  if ! defined(Package['libXmu.i686'])                { package { 'libXmu.i686':                ensure => present } }
  if ! defined(Package['libXtst'])                    { package { 'libXtst':                    ensure => present } }
  if ! defined(Package['libXtst.i686'])               { package { 'libXtst.i686':               ensure => present } }
  if ! defined(Package['pam'])                        { package { 'pam':                        ensure => present } }
  # pam.i686 is required according to the documentation but errors when we try to install it
  #if ! defined(Package['pam.i686'])                   { package { 'pam.i686':                   ensure => present } }
  if ! defined(Package['libXft'])                     { package { 'libXft':                     ensure => present } }
  if ! defined(Package['libXft.i686'])                { package { 'libXft.i686':                ensure => present } }

  # Required by IBM HTTP Server
  #if ! defined(Package['compat-db'])                  { package { 'compat-db':                  ensure => present } }
  #if ! defined(Package['compat-db.i686'])             { package { 'compat-db.i686':             ensure => present } }
  #if ! defined(Package['ksh'])                        { package { 'ksh':                        ensure => present } }
}

