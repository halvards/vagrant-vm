class sonar::host {
  include java::oraclejdk7
  include sonar::postgresql
  include sonar::user
  include utils::base

  $sonar_version = '3.1.1'
  $sonar_name = "sonar-${sonar_version}"
  $sonar_zip_file = "${sonar_name}.zip"
  $sonar_zip_file_location = "/vagrant-share/apps/${sonar_zip_file}"
  $sonar_home = "/opt/${sonar_name}"

  wget::fetch { 'sonar-server':
    source      => "http://dist.sonar.codehaus.org/${sonar_zip_file}",
    destination => $sonar_zip_file_location,
  }

  exec { 'extract-sonar-server':
    command => "/usr/bin/unzip $sonar_zip_file_location -d /opt",
    creates => "${sonar_home}/bin/linux-x86-64/sonar.sh",
    require => [Wget::Fetch['sonar-server'], Package['unzip']],
  }

  exec { 'set-sonar-file-permissions':
    command => "/bin/chmod --recursive g+w ${sonar_home} && /bin/chown -R sonar:sonar ${sonar_home}",
    unless  => "/bin/ls -ld ${sonar_home} | /bin/grep -q 'rwxr.x .* sonar sonar' -",
    require => [Exec['extract-sonar-server'], User['sonar']],
  }

  file { '/etc/init.d/sonar':
    ensure => present,
    group  => 'root',
    mode   => 0755,
    owner  => 'root',
    source => '/vagrant-share/conf/sonar/sonar.rc',
  }

  file { '/usr/bin/sonar':
    ensure  => link,
    target  => "${sonar_home}/bin/linux-x86-64/sonar.sh",
    require => Exec['extract-sonar-server'],
  }

  exec { 'register-sonar-at-boot-time':
    command => '/usr/sbin/update-rc.d sonar defaults',
    creates => '/etc/rc3.d/S20sonar',
    require => [File['/etc/init.d/sonar', '/usr/bin/sonar']],
  }

  service { 'sonar':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require => [Class['java::oraclejdk7'], File['/etc/init.d/sonar', '/usr/bin/sonar'], Exec['set-sonar-file-permissions'], Class['sonar::postgresql']],
  }
}

