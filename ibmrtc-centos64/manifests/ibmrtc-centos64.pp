# Note: This recipe downloads the entire IBM Rational Team Concert from the IBM Rational Jazz website

include timezone::sydney
include selinux::disable
include iptables::disable
include utils::vcs
include ibm::rtc

class ibm::rtc {
  include utils::base
  include selinux::disable

  $ibmim_location = '/vagrant-share/apps/IBMIM_linux_x86.zip'
  $ibmim_dir = '/tmp/ibmim'
  $ibmrtc_localrepo_zip = '/vagrant-share/apps/JTS-CCM-QM-RM-repo-3.0.1.zip'
  $ibmrtc_localrepo_dir = '/tmp/ibmrtc-localrepo'
  $ibmim_package = 'com.ibm.cic.agent'
  $ibmrtc_license_package = 'com.ibm.team.install.jfs.app.product-rtc-standalone'
  $ibmrtc_package = 'com.ibm.team.install.calm'

  $open_files_config_file = '/etc/security/limits.conf'

  wgetfetch { 'ibmim':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/144/zips/agent.installer.linux.gtk.x86_1.4.4000.20110525_1254.zip',
    destination => $ibmim_location,
  }

  exec { 'extract-ibmim':
    command => "/usr/bin/unzip $ibmim_location -d $ibmim_dir",
    creates => '/tmp/ibmim/install',
    require => [Wgetfetch['ibmim'], Package['unzip']],
  }

  wgetfetch { 'ibmrtc-localrepo':
    source => 'http://ca-toronto-dl.jazz.net/mirror/downloads/rational-team-concert/3.0.1/3.0.1/JTS-CCM-QM-RM-repo-3.0.1.zip?tjazz=T5vC16uN3jR4b6or655E9QQ8624lkU',
    #source => 'http://ca-toronto-dl.jazz.net/mirror/downloads/rational-team-concert/3.0.1/3.0.1/RTC-BuildSystem-Toolkit-repo-3.0.1.zip?tjazz=OHawoIl49dX8166JLY0Xu51Au19GtQ',
    destination => $ibmrtc_localrepo_zip,
  }

  exec { 'extract-ibmrtc-localrepo':
    command => "/usr/bin/unzip $ibmrtc_localrepo_zip -d $ibmrtc_localrepo_dir",
    creates => "$ibmrtc_localrepo_dir/repository.config",
    require => [Wgetfetch['ibmrtc-localrepo'], Package['unzip']],
  }

  file { $open_files_config_file:
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '644',
  }

  line { 'increase-hard-open-files-limit':
    file => $open_files_config_file,
    line => '* hard nofile 12000',
    require => File[$open_files_config_file],
  }

  line { 'increase-soft-open-files-limit':
    file => $open_files_config_file,
    line => '* soft nofile 12000',
    require => File[$open_files_config_file],
  }

  exec { 'install-ibmrtc':
    command => "$ibmim_dir/tools/imcl install $ibmrtc_license_package $ibmrtc_package -repositories $ibmrtc_localrepo_dir/repository.config -acceptLicense -showVerboseProgress -installFixes recommended",
    creates => '/opt/IBM/JazzTeamServer/server/server.startup',
    timeout => 3600, #seconds
    logoutput => true,
    require => [Exec['extract-ibmim'], Exec['extract-ibmrtc-localrepo']],
  }

  service { 'ibmrtc':
    enable => true,
    ensure => running,
    hasrestart => false,
    provider => base,
    start => '/opt/IBM/JazzTeamServer/server/server.startup',
    status => '/bin/ps -ef | grep [J]azzTeamServer',
    stop => '/opt/IBM/JazzTeamServer/server/server.shutdown',
    require => [Exec['install-ibmrtc'], Exec['disable-selinux']],
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

class selinux::disable {
  exec { 'disable-selinux':
    command => '/usr/sbin/setenforce 0',
  }
}

class iptables::disable {
  package { 'iptables':
    ensure => present,
  }

  service { 'iptables':
    enable => false,
    ensure => stopped,
    hasrestart => true,
    hasstatus => true,
    require => Package['iptables'],
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

define line($file, $line, $ensure = 'present') {
  case $ensure {
    default : { err ( "unknown ensure value ${ensure}" ) }
    present: {
      exec { "/bin/echo '${line}' >> '${file}'":
        unless => "/bin/grep -qFx '${line}' '${file}'"
      }
    }
    absent: {
      exec { "/bin/grep -vFx '${line}' '${file}' | /usr/bin/tee '${file}' > /dev/null 2>&1":
        onlyif => "/bin/grep -qFx '${line}' '${file}'"
      }
    }
  }
}

