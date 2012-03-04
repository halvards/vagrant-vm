class java::oraclejdk7 {
  case $operatingsystem {
    'CentOS': {
      $jdk_version = '7u3'
      $jdk_version_long = "${jdk_version}-b04"
      $jdk_rpm_filename = "jdk-${jdk_version}-linux-x64.rpm"
      $jdk_rpm_location = "/vagrant-share/apps/${rpm_filename}"

      wget::fetch { 'oraclejdk7':
        source => "http://download.oracle.com/otn-pub/java/jdk/${jdk_version_long}/jdk-${jdk_version}-linux-x64.rpm",
        destination => $jdk_rpm_location,
      }

      package { 'oraclejdk7':
        provider => 'rpm',
        source => $jdk_rpm_location,
        require => Wget::Fetch['oraclejdk7'],
      }
    }
    'Ubuntu': {
      include debrepos::java

      package { 'oracle-java7-jdk':
        ensure => present,
        require => Class['debrepos::java'],
      }
    }
  }
}

