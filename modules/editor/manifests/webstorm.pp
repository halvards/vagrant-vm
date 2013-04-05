class editor::webstorm($jdk = 'oraclejdk7') {
  include utils::inotifylimit
  include vagrant::user
  case $jdk {
    'oraclejdk7': {
      include java::oraclejdk7
    }
    'sunjdk6': {
      include java::sunjdk6
    }
    default: {
      fail "Invalid Java SDK value '${jdk}' specified for WebStorm"
    }
  }

  $webstorm_version = '6.0.1a'
  $webstorm_build = '127.122'
  $webstorm_tarball_name = "WebStorm-${webstorm_version}.tar.gz"
  $webstorm_config_dir = '/home/vagrant/.WebStorm6'

  wget::fetch { 'webstorm':
    source      => "http://download.jetbrains.com/webstorm/${webstorm_tarball_name}",
    destination => "/vagrant-share/apps/${webstorm_tarball_name}",
  }

  exec { "extract-webstorm":
    command => "/bin/tar -zxf /vagrant-share/apps/${webstorm_tarball_name} --directory=/opt",
    creates => "/opt/WebStorm-${webstorm_build}/bin",
    require => Wget::Fetch['webstorm'],
  }

  file { "/opt/WebStorm":
    ensure  => link,
    target  => "/opt/WebStorm-${webstorm_build}",
    require => Exec['extract-webstorm'],
  }

  file { '/usr/local/bin/webstorm.sh':
    ensure  => link,
    target  => '/opt/WebStorm/bin/webstorm.sh',
    require => File['/opt/WebStorm'],
  }

  file { '/opt/WebStorm/bin/webstorm48.png':
    ensure  => present,
    mode    => 664,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => "/vagrant-share/conf/webstorm/webstorm48.png",
    require => [File['/opt/WebStorm'], User['vagrant'], Group['vagrant']],
  }

  file { '/home/vagrant/Desktop/webstorm.desktop':
    ensure  => present,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/webstorm/webstorm.desktop',
  }

  file { "$webstorm_config_dir":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => [User['vagrant'], Group['vagrant']],
  }

  file { "$webstorm_config_dir/config":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$webstorm_config_dir"],
  }

  file { "$webstorm_config_dir/config/plugins":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$webstorm_config_dir/config"],
  }

  # Disable Webstorm plugins not needed
  file { "${webstorm_config_dir}/config/disabled_plugins.txt":
    ensure  => present,
    mode    => 664,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/webstorm/disabled_plugins.txt',
    require => File["${webstorm_config_dir}/config"],
  }

  case $operatingsystem {
    'Ubuntu': {
      include ubuntu::keybindings

      if ! defined(Package['gtk2-engines-pixbuf']) {
        package { 'gtk2-engines-pixbuf':
          ensure => present,
        }
      }
    }
  }
}

