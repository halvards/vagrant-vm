# This recipe does not work as DB2 Express fails to install correctly.
#
# http://publib.boulder.ibm.com/infocenter/dmndhelp/v7r5mx/index.jsp?topic=%2Fcom.ibm.wbpm.wid.imuc.doc%2Ftopics%2Fc_inintro.html
class ibm::integration-designer {
  include ibm::id-prereqs
  include ibm::im-root
  include ibm::im-user

  $ibm_location = '/home/vagrant/IBM'
  $ibm_id_repo = '/vagrant-share/apps/ibmrepos/id'
  $ibm_id_package = 'com.ibm.websphere.integration.developer.v75'
  $ibm_id_install_location = "${ibm_location}/IntegrationDesigner"

  $ibm_id_wte_repo = '/vagrant-share/apps/ibmrepos/id-wte/WTE_Disk/repository'
  $ibm_was_package = 'com.ibm.websphere.ND.v70,core.feature,samples,import.productProviders.feature,import.configLauncher.feature,consoleLanguagesSupport.feature,runtimeLanguagesSupport.feature'
  $ibm_db2_package = 'com.ibm.ws.DB2EXP97.linuxia64'
  $ibm_bpmps_package = 'com.ibm.ws.WBPMPS,wps.client.feature,wps.server.feature,wps.samples.feature,wps.profile.feature'
  $ibm_bpmps_package_no_db2 = 'com.ibm.ws.WBPMPS,wps.client.feature,wps.server.feature'
  $ibm_sca_package = 'com.ibm.websphere.SCA.v10'
  $ibm_xml_package = 'com.ibm.websphere.XML.v10'
  $ibm_id_wte_packages = "$ibm_bpmps_package $ibm_was_package $ibm_sca_package $ibm_xml_package"

  $ibm_was_install_properties = 'user.select.64bit.image,,com.ibm.websphere.ND.v70=true'
  $ibm_db2_install_properties = 'user.db2.port=50000,user.db2.instance.username=bpminst,user.db2.instance.password=bpminst1,user.db2.fenced.username=bpmfenc,user.db2.fenced.password=bpmfenc1,user.db2.das.username=bpmadmin,user.db2.das.password=bpmadmin1'

  # http://publib.boulder.ibm.com/infocenter/dmndhelp/v7r5mx/index.jsp?topic=%2Fcom.ibm.wbpm.wid.imuc.doc%2Ftopics%2Ftins_silent_install.html
  exec { 'install-ibm-id':
    command   => "/bin/bash -c 'ulimit -n 12000' && ${ibm_location}/InstallationManager/eclipse/tools/imcl install $ibm_id_package -repositories $ibm_id_repo -installationDirectory $ibm_id_install_location -acceptLicense -showProgress -installFixes recommended",
    user      => 'vagrant',
    creates   => "${ibm_id_install_location}/eclipse",
    timeout   => 1200, #seconds
    logoutput => true,
    require   => [Exec['install-ibm-im'], Class['Ibm::Id-prereqs']],
  }

  # Fails for reasons I do not understand
  exec { 'install-ibm-db2':
    command   => "/bin/bash -c 'ulimit -n 12000' && /opt/IBM/InstallationManager/eclipse/tools/imcl install $ibm_db2_package $ibm_was_package -repositories $ibm_id_wte_repo -properties ${ibm_was_install_properties},${ibm_db2_install_properties} -acceptLicense -showProgress -installFixes recommended",
    creates   => "/opt/IBM/WebSphere/AppServer",
    timeout   => 3600, #seconds
    logoutput => true,
    require   => Exec['install-ibm-id'],
  }

  # http://publib.boulder.ibm.com/infocenter/dmndhelp/v7r5mx/index.jsp?topic=%2Fcom.ibm.wbpm.wid.imuc.doc%2Ftopics%2Ftins_silent_inst_cmd.html
  exec { 'install-ibm-id-wte':
    command   => "/bin/bash -c 'ulimit -n 12000' && ${ibm_location}/InstallationManager/eclipse/tools/imcl install $ibm_id_wte_packages -repositories $ibm_id_wte_repo -properties ${ibm_was_install_properties} -acceptLicense -showProgress -installFixes recommended",
    user      => 'vagrant',
    creates   => "${ibm_location}/WebSphere/AppServer",
    timeout   => 1800, #seconds
    logoutput => true,
    require   => Exec['install-ibm-db2'],
  }
}

class ibm::id-prereqs {
  $open_files_config_file = '/etc/security/limits.conf'
  $open_files_limit = '12000'

  # Increase file handle limit, see http://publib.boulder.ibm.com/infocenter/dmndhelp/v7r5mx/index.jsp?topic=%2Fcom.ibm.wbpm.wid.imuc.doc%2Ftopics%2Ft_pre_install_tasks.html
  file { $open_files_config_file:
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '644',
  }

  line::present { 'increase-hard-open-files-limit':
    file => $open_files_config_file,
    line => "* hard nofile $open_files_limit",
    require => File[$open_files_config_file],
  }

  line::present { 'increase-soft-open-files-limit':
    file => $open_files_config_file,
    line => "* soft nofile $open_files_limit",
    require => File[$open_files_config_file],
  }

  exec { 'increase-open-file-limit-immediately':
    command => "/bin/bash -c 'ulimit -n ${open_files_limit}'",
    unless  => "/bin/bash -c 'ulimit -n' | /bin/grep $open_files_limit",
  }

  # http://publib.boulder.ibm.com/infocenter/dmndhelp/v7r5mx/index.jsp?topic=%2Fcom.ibm.wbpm.wid.imuc.doc%2Ftopics%2Ft_pre_install_tasks.html
  if ! defined(Package['compat-db'])                  { package { 'compat-db':                  ensure => present } }
  if ! defined(Package['compat-db.i686'])             { package { 'compat-db.i686':             ensure => present } }
  if ! defined(Package['compat-libstdc++-296.i686'])  { package { 'compat-libstdc++-296.i686':  ensure => present } }
  if ! defined(Package['glibc.i686'])                 { package { 'glibc.i686':                 ensure => present } }
  if ! defined(Package['ksh'])                        { package { 'ksh':                        ensure => present } }
  if ! defined(Package['libXp.i686'])                 { package { 'libXp.i686':                 ensure => present } }
  if ! defined(Package['rpm-build'])                  { package { 'rpm-build':                  ensure => present } }
}

