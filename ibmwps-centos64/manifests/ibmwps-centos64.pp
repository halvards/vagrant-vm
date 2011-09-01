# Note: This recipe downloads the entire IBM WebSphere Application Server V8.0 for developers from the public IBM repository

include timezone::sydney
include ibm::wps

class ibm::wps {
  include utils::base
  include ibm::wps-prereqs

  $ibm_username = ''
  $ibm_password = ''
  $ibmim_location = '/vagrant-share/apps/IBMIM_linux_x86.zip'
  $ibm_was8_package = 'com.ibm.websphere.DEVELOPERSILAN.v80_8.0.0.20110503_0200'
  $ibm_was8_repo = 'http://www-912.ibm.com/software/repositorymanager/V8WASDeveloperILAN/repository.config'
  $ibm_keyring_file = '/vagrant-share/apps/ibm-keyring-trial'

  wget::fetch { 'ibm-im-was8':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/144/zips/agent.installer.linux.gtk.x86_1.4.4000.20110525_1254.zip',
    destination => $ibmim_location,
  }

  exec { 'extract-ibm-im':
    command => "/usr/bin/unzip $ibmim_location -d /tmp/ibmim/",
    creates => '/tmp/ibmim/install',
    require => [Wget::Fetch['ibm-im-was8'], Package['unzip']],
  }

  exec { 'create-ibm-keyring-file':
    command => "/tmp/ibmim/tools/imutilsc saveCredential -url $ibm_was8_repo -userName $ibm_username -userPassword $ibm_password -keyring $ibm_keyring_file",
    creates => $ibm_keyring_file,
    logoutput => true,
    require => Exec['extract-ibm-im'],
  }

  exec { 'install-was8':
    command => "/tmp/ibmim/tools/imcl install $ibm_was8_package -repositories $ibm_was8_repo -acceptLicense -showVerboseProgress -installFixes recommended -keyring $ibm_keyring_file",
    creates => '/opt/IBM/WebSphere/AppServer/bin/startServer.sh',
    timeout => 36000, #seconds
    logoutput => true,
    require => Exec['create-ibm-keyring-file'],
  }

  exec { 'create-was-profile':
    command => '/bin/echo TODO Do not yet know how to create profiles automatically for IBM WebSphere Application Server',
    logoutput => true,
    require => Exec['install-was8'],
  }
}

class ibm::was-prereqs {
  package { ['compat-libstdc++-33', 'libXp', 'libXmu', 'libXtst', 'pam', 'rpm-build', 'elfutils', 'elfutils-libs', 'libXft', 'libstdc++', 'libgcc.i386', 'libgcc.x86_64', 'libswt3-gtk2', 'gtk2.i386', 'gtk2.x86_64']:
    ensure => present,
  }
}

