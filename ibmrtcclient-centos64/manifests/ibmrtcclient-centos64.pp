# Note: This recipe downloads the IBM Rational Team Concert Eclipse client from the Jazz website (0.5 GB)

include timezone::sydney
include utils::vcs
include ibm::rtcclient

class ibm::rtcclient {
  include utils::base
  include selinux::disable

  $ibmim_location = '/vagrant-share/apps/IBMIM_linux_x86.zip'
  $ibmim_dir = '/tmp/ibmim'
  $ibmrtcclient_localrepo_zip = '/vagrant-share/apps/RTC-Eclipse-Client-repo-3.0.1.zip'
  $ibmrtcclient_localrepo_unzip_dir = '/tmp/ibmrtcclient-localrepo'
  $ibmrtcclient_localrepo_dir = "$ibmrtcclient_localrepo_unzip_dir/im/repo/rtc-client-offering/offering-repo"
  $ibmim_package = 'com.ibm.cic.agent'
  $ibmrtc_license_package = 'com.ibm.team.install.jfs.app.product-rtc-standalone'
  $ibmrtcclient_package = 'com.ibm.team.install.rtc.client.eclipse'

  wgetfetch { 'ibmim':
    source => 'http://public.dhe.ibm.com/software/rationalsdp/v7/im/144/zips/agent.installer.linux.gtk.x86_1.4.4000.20110525_1254.zip',
    destination => $ibmim_location,
  }

  exec { 'extract-ibmim':
    command => "/usr/bin/unzip $ibmim_location -d $ibmim_dir",
    creates => '/tmp/ibmim/install',
    require => [Wgetfetch['ibmim'], Package['unzip']],
  }

  wgetfetch { 'ibmrtcclient-localrepo':
    source => 'http://ca-toronto-dl.jazz.net/mirror/downloads/rational-team-concert/3.0.1/3.0.1/RTC-Eclipse-Client-repo-3.0.1.zip?tjazz=Dkh92Gk2mbcuU657Y699Qs1eIFsq10',
    destination => $ibmrtcclient_localrepo_zip,
  }

  exec { 'extract-ibmrtcclient-localrepo':
    command => "/usr/bin/unzip $ibmrtcclient_localrepo_zip -d $ibmrtcclient_localrepo_unzip_dir",
    creates => "$ibmrtcclient_localrepo_dir/repository.config",
    require => [Wgetfetch['ibmrtcclient-localrepo'], Package['unzip']],
  }

  exec { 'install-ibmrtcclient':
    command => "$ibmim_dir/tools/imcl install $ibmrtcclient_package -repositories $ibmrtcclient_localrepo_dir/repository.config -acceptLicense -showVerboseProgress -installFixes recommended",
    creates => '/opt/IBM/TeamConcert/eclipse',
    timeout => 3600, #seconds
    logoutput => true,
    require => [Exec['extract-ibmim'], Exec['extract-ibmrtcclient-localrepo']],
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

