class editor::pycharm($jdk = 'oraclejdk7') {
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
      fail "Invalid Java SDK value '${jdk}' specified for pycharm"
    }
  }

  $pycharm_version = '2.7.3'
  $pycharm_build = '129.782'
  $pycharm_tarball_name = "pycharm-${pycharm_version}.tar.gz"
  $pycharm_config_dir = '/home/vagrant/.PyCharm20'

  wget::fetch { 'pycharm':
    source      => "http://download.jetbrains.com/python/${pycharm_tarball_name}",
    destination => "/vagrant-share/apps/${pycharm_tarball_name}",
  }

  exec { "extract-pycharm":
    command => "/bin/tar -zxf /vagrant-share/apps/${pycharm_tarball_name} --directory=/opt",
    creates => "/opt/pycharm-${pycharm_version}/bin",
    require => Wget::Fetch['pycharm'],
  }

  file { "/opt/pycharm":
    ensure  => link,
    target  => "/opt/pycharm-${pycharm_version}",
    require => Exec['extract-pycharm'],
  }

  file { '/usr/local/bin/pycharm.sh':
    ensure  => link,
    target  => '/opt/pycharm/bin/pycharm.sh',
    require => File['/opt/pycharm'],
  }

  file { '/home/vagrant/Desktop/pycharm.desktop':
    ensure  => present,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/pycharm/pycharm.desktop',
  }

  file { "$pycharm_config_dir":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => [User['vagrant'], Group['vagrant']],
  }

  file { "$pycharm_config_dir/config":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$pycharm_config_dir"],
  }

  file { "$pycharm_config_dir/config/plugins":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$pycharm_config_dir/config"],
  }

  # Disable pycharm plugins not needed
  file { "${pycharm_config_dir}/config/disabled_plugins.txt":
    ensure  => present,
    mode    => 664,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/pycharm/disabled_plugins.txt',
    require => File["${pycharm_config_dir}/config"],
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

