class editor::rubymine($jdk = 'oraclejdk7') {
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
      fail "Invalid Java SDK value '${jdk}' specified for RubyMine"
    }
  }

  $rubymine_version = '5.0.2'
  $rubymine_build = '125.94'
  $rubymine_tarball_name = "RubyMine-${rubymine_version}.tar.gz"
  $rubymine_config_dir = '/home/vagrant/.RubyMine50'

  wget::fetch { 'rubymine':
    source      => "http://download.jetbrains.com/ruby/${rubymine_tarball_name}",
    destination => "/vagrant-share/apps/${rubymine_tarball_name}",
  }

  exec { "extract-rubymine":
    command => "/bin/tar -zxf /vagrant-share/apps/${rubymine_tarball_name} --directory=/opt",
    creates => "/opt/RubyMine-${rubymine_version}/bin",
    require => Wget::Fetch['rubymine'],
  }

  file { "/opt/RubyMine":
    ensure  => link,
    target  => "/opt/RubyMine-${rubymine_version}",
    require => Exec['extract-rubymine'],
  }

  file { '/usr/local/bin/rubymine.sh':
    ensure  => link,
    target  => '/opt/RubyMine/bin/rubymine.sh',
    require => File['/opt/RubyMine'],
  }

  file { '/home/vagrant/Desktop/rubymine.desktop':
    ensure  => present,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/rubymine/rubymine.desktop',
  }

  file { "$rubymine_config_dir":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => [User['vagrant'], Group['vagrant']],
  }

  file { "$rubymine_config_dir/config":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$rubymine_config_dir"],
  }

  file { "$rubymine_config_dir/config/plugins":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$rubymine_config_dir/config"],
  }

  # Disable rubymine plugins not needed
  file { "${rubymine_config_dir}/config/disabled_plugins.txt":
    ensure  => present,
    mode    => 664,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/rubymine/disabled_plugins.txt',
    require => File["${rubymine_config_dir}/config"],
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

