class java::oraclejdk7 {
  case $operatingsystem {
    'CentOS': {
      $rpm_filename = 'jdk-7-linux-x64.rpm'
      $rpm_location = "/vagrant-share/apps/${rpm_filename}"

      wget::fetch { 'oraclejdk7':
        source => 'http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-x64.rpm',
        destination => $rpm_location,
      }

      package { 'oraclejdk7':
        provider => 'rpm',
        source => $rpm_location,
        require => Wget::Fetch['oraclejdk7'],
      }
    }
    'Ubuntu': {
      $tarball_filename = 'jdk-7-linux-x64.tar.gz'
      $tarball_location = "/vagrant-share/apps/${tarball_filename}"

      wget::fetch { 'oraclejdk7':
        source => 'http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-x64.tar.gz',
        destination => $tarball_location,
      }

      file { '/usr/lib/jvm':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => 0755,
      }

      exec { 'extract-oraclejdk7':
        command => "/bin/tar -zxf ${tarball_location} --directory=/usr/lib/jvm",
        creates => '/usr/lib/jvm/jdk1.7.0',
        require => [Wget::Fetch['oraclejdk7'], File['/usr/lib/jvm']],
      }

      file { '/usr/lib/jvm/java-7-oraclejdk-amd64':
        ensure => link,
        target => '/usr/lib/jvm/jdk1.7.0',
        require => Exec['extract-oraclejdk7'],
      }

      package { ['ca-certificates-java', 'default-jre', 'default-jre-headless', 'java-common', 'libswing-layout-java', 'tzdata-java', 'visualvm']:
        ensure => present,
      }

      debrepos::pparepo { 'nilarimogard/webupd8':
        apt_key => '4C9D234C',
      }

      exec { 'update-apt-cache-webupd8':
        command => '/usr/bin/apt-get update',
        require => Debrepos::Pparepo['nilarimogard/webupd8'],
      }

      package { 'update-java':
        ensure => present,
        require => Exec['update-apt-cache-webupd8'],
      }

      package { 'gksu':
        ensure => present,
      }
    }
  }
}

