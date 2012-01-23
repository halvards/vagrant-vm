# IBM Rational Jazz Team Concert Source Control GUI Client
class ibm::rtc-uiclient {
  include ibm::installation-manager

  $ibm_rtcclient_package = 'com.ibm.team.install.rtc.client.eclipse'
  $ibm_rtcclient_repo = '/vagrant-share/apps/ibmrepos/rtcclient'

  exec { 'install-rtc-uiclient':
    command => "/opt/IBM/InstallationManager/eclipse/tools/imcl install $ibm_rtcclient_package -repositories $ibm_rtcclient_repo -acceptLicense -showProgress -installFixes recommended",
    creates => '/opt/IBM/TeamConcert/scmtools',
    require => Exec['install-ibm-im'],
  }
}

