# IBM WebSphere Application Server V7 for WebSphere Integration Developer test environment
class ibm::was {
  include ibm::was-prereqs
  include ibm::wid

  #$ibm_location = '/opt/IBM'
  $ibm_location = '/home/vagrant/IBM'
  $ibm_wte_installer = '/vagrant-share/apps/ibmrepos'
  $ibm_was_home = "${ibm_location}/WID7_WTE/runtimes/bi_v7"

  exec { 'install-ibm-was':
    command   => "/bin/bash ${ibm_wte_installer}/WTE_Disk/scripts/installWAS.sh $ibm_wte_installer $ibm_was_home",
    user      => 'vagrant',
    creates   => $ibm_was_home,
    timeout   => 1800, # seconds
    logoutput => true,
    require   => [Exec['install-ibm-wid'], Class['Ibm::Was-prereqs']],
  }

  exec { 'import-ibm-was':
    command   => "${ibm_location}/InstallationManager/eclipse/tools/imcl -input /vagrant-share/conf/ibmwas-import.xml -acceptLicense -showProgress",
    user      => 'vagrant',
    creates   => "${ibm_was_home}/properties/version/im/ND.im.properties",
    timeout => 1200, # seconds
    logoutput => true,
    require   => Exec['install-ibm-was'],
  }
}

class ibm::was-prereqs {
  # Required by InstallShield MultiPlatform (ISMP) used by IBM WebSphere Application Server V7 and earlier
  if ! defined(Package['rpm-build'])                  { package { 'rpm-build':                  ensure => present } }
}

