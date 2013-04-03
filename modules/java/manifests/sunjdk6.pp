class java::sunjdk6 {
  case $operatingsystem {
    'CentOS': {
      include utils::base

      $jdk6_version = '6u43'
      $jdk6_version_long = "${jdk6_version}-b01"

      $jdk6_rpmbin_filename = "jdk-${jdk6_version}-linux-x64-rpm.bin"
      $jdk6_rpmbin_location = "/vagrant-share/apps/${jdk6_rpmbin_filename}"
      $jdk6_rpm_filename = "jdk-${jdk6_version}-linux-amd64.rpm"
      $jdk6_rpm_location = "/vagrant-share/apps/${jdk6_rpm_filename}"

      wget::fetch { 'sunjdk6':
        source      => "--header='Cookie: gpw_e24=notempty' --no-check-certificate http://download.oracle.com/otn-pub/java/jdk/${jdk6_version_long}/jdk-${jdk6_version}-linux-x64-rpm.bin",
        destination => $jdk6_rpmbin_location,
      }

      exec { 'install-sunjdk6-rpm':
        command   => "/bin/bash ${jdk6_rpmbin_location} && /bin/rm /vagrant-share/apps/sun-javadb-*.rpm && /bin/rm /vagrant-share/apps/jdk-6u41-linux-amd64.rpm",
        cwd       => '/vagrant-share/apps',
        #creates   => $jdk6_rpm_location,
        require   => Wget::Fetch['sunjdk6'],
      }
    }
    'Ubuntu': {
      include debrepos::oabjava6

      package { 'sun-java6-jdk':
        ensure  => present,
        require => Class['debrepos::oabjava6'],
      }
    }
  }
}

