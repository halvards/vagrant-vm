# Note: This recipe downloads the entire IBM Rational Team Concert from the IBM Rational Jazz website

include timezone::sydney
include utils::vcs
include ibm::rtcinstaller

class ibm::rtcinstaller {
  include utils::base

  $ibmrtc_installer_zip = '/vagrant-share/apps/RTC-Web-Installer-Linux-3.0.1.zip'
  $ibmrtc_license_zip = '/vagrant-share/apps/RTC-Developer-10-C-License-3.0.1.zip'
  $ibmrtc_localrepo_zip = '/vagrant-share/apps/JTS-CCM-QM-RM-repo-3.0.1.zip'
  $ibmrtc_installer_dir = '/vagrant-share/apps/ibmrtc-installer'
  $ibmrtc_localrepo_dir = '/vagrant-share/apps/ibmrtc-localrepo'

  wgetfetch { 'ibmrtc-installer':
      #source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/144/zips/agent.installer.linux.gtk.x86_1.4.4000.20110525_1254.zip',
    source => 'http://jazz.net/downloads/rational-team-concert/releases/3.0.1/RTC-Web-Installer-Linux-3.0.1.zip',
    destination => $ibmrtc_installer_zip,
  }

  file { $ibmrtc_installer_dir:
    ensure => directory,
  }

  exec { 'extract-ibmrtc-installer':
    command => "/usr/bin/unzip $ibmrtc_installer_zip -d $ibmrtc_installer_dir",
    creates => "$ibmrtc_installer_dir/launchpad.sh",
    require => [Wgetfetch['ibmrtc-installer'], File[$ibmrtc_installer_dir], Package['unzip']],
  }

  wgetfetch { 'ibmrtc-license':
    source => 'http://jazz.net/downloads/rational-team-concert/releases/3.0.1/RTC-Developer-10-C-License-3.0.1.zip',
    destination => $ibmrtc_license_zip,
  }

  exec { 'extract-ibmrtc-license':
    command => "/usr/bin/unzip $ibmrtc_license_zip -d $ibmrtc_installer_dir",
    creates => "$ibmrtc_installer_dir/RTC_Developer-10_Unlocked.jar",
    require => [Wgetfetch['ibmrtc-license'], File[$ibmrtc_installer_dir], Package['unzip']],
  }

  wgetfetch { 'ibmrtc-localrepo':
    source => 'http://jazz.net/downloads/rational-team-concert/releases/3.0.1/JTS-CCM-QM-RM-repo-3.0.1.zip',
    #source => 'https://jazz.net/downloads/rational-team-concert/releases/3.0.1/RTC-BuildSystem-Toolkit-repo-3.0.1.zip',
    destination => $ibmrtc_localrepo_zip,
  }

  file { $ibmrtc_localrepo_dir:
    ensure => directory,
  }

  exec { 'extract-ibmrtc-localrepo':
    command => "/usr/bin/unzip $ibmrtc_localrepo_zip -d $ibmrtc_localrepo_dir",
    creates => "$ibmrtc_localrepo_dir/repository.config",
    require => [Wgetfetch['ibmrtc-localrepo'], File[$ibmrtc_localrepo_dir], Package['unzip']],
  }
}

class utils::vcs {
  include repos::epel

  package { ['mercurial', 'git']:
    ensure => present,
    require => Package['epel-release'],
  }
}

class utils::base {
  package { ['bash', 'wget', 'curl', 'patch', 'unzip', 'sed', 'tar', 'gzip', 'bzip2', 'man', 'vim-minimal']:
    ensure => present,
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

class timezone::sydney {
  file { '/etc/localtime':
    ensure => link,
    target => '/usr/share/zoneinfo/Australia/Sydney',
    owner => root,
    group => root,
  }
}

define wgetfetch($source,$destination) {
  exec { "wget-$name":
    command => "/usr/bin/wget --output-document=$destination $source",
    creates => "$destination",
    timeout => 3600, # seconds
    require => Package['wget'],
  }
}

