# IBM WebSphere Application Server V7 for WebSphere Integration Developer test environment
class ibm::was {
  include ibm::was-prereqs
  include ibm::wid
  include utils::base

  $ibm_wte_installer = '/vagrant-share/apps/ibmrepos'
  $ibm_was_home = '/opt/IBM/WID7_WTE/runtimes/bi_v7'

  exec { 'install-ibm-was':
    command => "/bin/bash ${ibm_wte_installer}/WTE_Disk/scripts/installWAS.sh $ibm_wte_installer $ibm_was_home",
    creates => $ibm_was_home,
    timeout => 1800, # seconds
    logoutput => true,
    require => [Exec['install-ibm-wid'], Class['Ibm::Was-prereqs']],
  }

  exec { 'import-ibm-was':
    command   => "/opt/IBM/InstallationManager/eclipse/tools/imcl -input /vagrant-share/conf/ibmwas-import.xml -acceptLicense -showProgress",
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

