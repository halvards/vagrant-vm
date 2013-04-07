class java::oraclejdk7 {
  case $operatingsystem {
    'CentOS': {
      include utils::base

      $jdk7_version = '7u17'
      $jdk7_version_long = "${jdk7_version}-b02"
      $jdk7_rpm_filename = "jdk-${jdk7_version}-linux-x64.rpm"
      $jdk7_rpm_location = "/vagrant-share/apps/${jdk7_rpm_filename}"

      wget::fetch { 'oraclejdk7':
        source      => "--header='Cookie: gpw_e24=notempty' --no-check-certificate http://download.oracle.com/otn-pub/java/jdk/${jdk7_version_long}/jdk-${jdk7_version}-linux-x64.rpm",
        destination => $jdk7_rpm_location,
      }

      package { 'oraclejdk7':
        provider => 'rpm',
        source   => $jdk7_rpm_location,
        require  => Wget::Fetch['oraclejdk7'],
      }
    }
    'Ubuntu': {
      include debrepos::java

      package { ['oracle-java7-installer']:
        ensure  => present,
        require => Class['debrepos::java'],
      }
    }
  }
}

