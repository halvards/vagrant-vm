# IBM WebSphere Process Server for IBM WebSphere Integration Developer test environment
# Also includes SCA and XML feature packs for WebSphere Application Server V7
class ibm::wps {
  include ibm::was

  exec { 'install-ibm-wps':
    command   => "/opt/IBM/InstallationManager/eclipse/tools/imcl -input /vagrant-share/conf/ibmwps-response.xml -acceptLicense -showProgress",
    creates => '/opt/IBM/WID7_WTE/runtimes/bi_v7/profiles/qwps',
    timeout => 3600, #seconds
    logoutput => true,
    require => Exec['import-ibm-was'],
  }
}
