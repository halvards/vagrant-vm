# IBM WebSphere Process Server for IBM WebSphere Integration Developer test environment
# Also includes SCA and XML feature packs for WebSphere Application Server V7
class ibm::wps {
  include ibm::was

  $ibm_location = '/home/vagrant/IBM'

  exec { 'install-ibm-wps':
    command   => "${ibm_location}/InstallationManager/eclipse/tools/imcl -input /vagrant-share/conf/ibmwps-response.xml -acceptLicense -showProgress",
    user      => 'vagrant',
    creates   => "${ibm_location}/WID7_WTE/runtimes/bi_v7/profiles/qwps",
    timeout   => 3600, #seconds
    logoutput => true,
    require   => Exec['import-ibm-was'],
  }
}

