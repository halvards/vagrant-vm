# Note: This recipe downloads the entire IBM WebSphere Application Server V8.0 for developers from the public IBM repository

class ibm::was {
  include utils::base
  include ibm::was-prereqs

  $ibm_username = ''
  $ibm_password = ''
  $ibmim_location = '/vagrant-share/apps/IBMIM_linux_x86.zip'
  $ibm_was8_package = 'com.ibm.websphere.DEVELOPERSILAN.v80_8.0.0.20110503_0200'
  $ibm_was8_repo = 'http://www-912.ibm.com/software/repositorymanager/V8WASDeveloperILAN/repository.config'
  $ibm_keyring_file = '/vagrant-share/apps/ibm-keyring-trial'

  wgetfetch { 'ibm-im-was8':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/144/zips/agent.installer.linux.gtk.x86_1.4.4000.20110525_1254.zip',
    destination => $ibmim_location,
  }

  exec { 'extract-ibm-im':
    command => "/usr/bin/unzip $ibmim_location -d /tmp/ibmim/",
    creates => '/tmp/ibmim/install',
    require => [Wgetfetch['ibm-im-was8'], Package['unzip']],
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
  package { ['compat-libstdc++-33', 'libXp', 'libXmu', 'libXtst', 'pam', 'rpm-build', 'elfutils', 'elfutils-libs', 'libXft', 'libstdc++']:
    ensure => present,
  }
}

class utils::base {
  package { ['bash', 'wget', 'curl', 'patch', 'unzip', 'sed', 'tar', 'gzip', 'bzip2', 'man']:
    ensure => present,
  }
}

class utils::vcs {
  include repos::epel

  package { ['mercurial', 'git']:
    ensure => present,
    require => Package['epel-release'],
  }
}

class repos::epel {
  package { 'epel-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/epel-release-5-4.noarch.rpm',
  }
}

class repos::elff {
  package { 'elff-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/elff-release-5-3.noarch.rpm',
  }
}

class repos::jpackage {
  package { ['jpackage-utils', 'yum-priorities']:
    ensure => present,
  }

  package { 'jpackage-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/jpackage-release-5-4.jpp5.noarch.rpm',
    require => [Package['jpackage-utils'], Package['yum-priorities']],
  }
}

define wgetfetch($source,$destination) {
  if $http_proxy {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => "$destination",
      timeout => 3600, #seconds
      require => Package['wget'],
      environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
    }
  } else {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => "$destination",
      timeout => 3600, #seconds
      require => Package['wget'],
    }
  }
}

include repos::jpackage
include utils::base
#include utils::vcs
include ibm::was

