class debrepos::oabjava6 {
  include utils::base

  $sunjava6_update = '43'
  $sunjava6_build  = 'b01'

  $sunjava6_version = "6u${sunjava6_update}"
  $sunjava6_version_long = "${sunjava6_version}-${sunjava6_build}"

  $sunjava6_i586_bin_filename  = "jdk-${sunjava6_version}-linux-i586.bin"
  $sunjava6_x64_bin_filename   = "jdk-${sunjava6_version}-linux-x64.bin"
  $sunjava6_jcepolicy_filename = 'jce_policy-6.zip'

  $sunjava6_i586_bin_download_url  = "http://download.oracle.com/otn-pub/java/jdk/${sunjava6_version_long}/${sunjava6_i586_bin_filename}"
  $sunjava6_x64_bin_download_url   = "http://download.oracle.com/otn-pub/java/jdk/${sunjava6_version_long}/${sunjava6_x64_bin_filename}"
  $sunjava6_jcepolicy_download_url = "http://download.oracle.com/otn-pub/java/jce_policy/6/${sunjava6_jcepolicy_filename}"

  $sunjava6_download_directory   = '/vagrant-share/apps'
  $sunjava6_oab_parent_directory = '/var/local'
  $sunjava6_oab_directory        = "${sunjava6_oab_parent_directory}/oab"
  $sunjava6_oab_pkg_directory    = "${sunjava6_oab_directory}/pkg"

  wget::fetch { 'sunjava6-i586':
    source      => "--header='Cookie: gpw_e24=notempty' --no-check-certificate ${sunjava6_i586_bin_download_url}",
    destination => "${sunjava6_download_directory}/${sunjava6_i586_bin_filename}",
  }

  wget::fetch { 'sunjava6-x64':
    source      => "--header='Cookie: gpw_e24=notempty' --no-check-certificate ${sunjava6_x64_bin_download_url}",
    destination => "${sunjava6_download_directory}/${sunjava6_x64_bin_filename}",
  }

  wget::fetch { 'sunjava6-jcepolicy':
    source      => "--header='Cookie: gpw_e24=notempty' --no-check-certificate ${sunjava6_jcepolicy_download_url}",
    destination => "${sunjava6_download_directory}/${sunjava6_jcepolicy_filename}",
  }

  file { $sunjava6_oab_parent_directory:
    ensure => directory,
  }

  file { $sunjava6_oab_directory:
    ensure  => directory,
    require => File[$sunjava6_oab_parent_directory],
  }

  file { $sunjava6_oab_pkg_directory:
    ensure => directory,
    require => File[$sunjava6_oab_directory],
  }

  file { "${sunjava6_oab_pkg_directory}/${sunjava6_i586_bin_filename}":
    ensure  => present,
    source  => "${sunjava6_download_directory}/${sunjava6_i586_bin_filename}",
    require => [Wget::Fetch['sunjava6-i586'], File[$sunjava6_oab_pkg_directory]],
  }

  file { "${sunjava6_oab_pkg_directory}/${sunjava6_x64_bin_filename}":
    ensure  => present,
    source  => "${sunjava6_download_directory}/${sunjava6_x64_bin_filename}",
    require => [Wget::Fetch['sunjava6-x64'], File[$sunjava6_oab_pkg_directory]],
  }

  file { "${sunjava6_oab_pkg_directory}/${sunjava6_jcepolicy_filename}":
    ensure  => present,
    source  => "${sunjava6_download_directory}/${sunjava6_jcepolicy_filename}",
    require => [Wget::Fetch['sunjava6-jcepolicy'], File[$sunjava6_oab_pkg_directory]],
  }

  if ! defined(Wget::Fetch['oab-java']) {
    wget::fetch { 'oab-java':
      source      => 'https://raw.github.com/flexiondotorg/oab-java6/master/oab-java.sh',
      destination => '/tmp/oab-java.sh',
    }
  }

  exec { 'add-local-oab-java6-apt-repo':
    command   => '/bin/bash /tmp/oab-java.sh',
    cwd       => '/tmp',
    creates   => '/var/local/oab/srcs/sun-java6.git',
    timeout   => 1800, # seconds
    logoutput => true,
    require   => [Wget::Fetch['oab-java'],
                  File["${sunjava6_oab_pkg_directory}/${sunjava6_i586_bin_filename}",
                       "${sunjava6_oab_pkg_directory}/${sunjava6_x64_bin_filename}",
                       "${sunjava6_oab_pkg_directory}/${sunjava6_jcepolicy_filename}"]],
  }
}

