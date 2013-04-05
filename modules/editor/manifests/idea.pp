class editor::idea($idea_edition = 'IU', $jdk = 'oraclejdk7') {
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
      fail "Invalid Java SDK value '${jdk}' specified for IntelliJ IDEA"
    }
  }

  $idea_name = "idea$idea_edition"
  $idea_version = '12.1'
  $idea_build = '129.161'
  $idea_tarball_name = "${idea_name}-${idea_version}.tar.gz"
  $idea_config_dir = $idea_edition ? {
    'IC' => '/home/vagrant/.IdeaIC12',
    'IU' => '/home/vagrant/.IntelliJIdea12',
  }

  wget::fetch { "$idea_name":
    source      => "http://download.jetbrains.com/idea/$idea_tarball_name",
    destination => "/vagrant-share/apps/$idea_tarball_name",
  }

  exec { "extract-$idea_name":
    command => "/bin/tar -zxf /vagrant-share/apps/$idea_tarball_name --directory=/opt",
    creates => "/opt/idea-${idea_edition}-${idea_build}/bin",
    require => Wget::Fetch["$idea_name"],
  }

  file { "/opt/$idea_name":
    ensure  => link,
    target  => "/opt/idea-${idea_edition}-${idea_build}",
    require => Exec["extract-$idea_name"],
  }

  file { "/usr/local/bin/idea.sh":
    ensure  => link,
    target  => "/opt/${idea_name}/bin/idea.sh",
    require => File["/opt/${idea_name}"],
  }

  file { "/opt/$idea_name/bin/idea48.png":
    ensure  => present,
    mode    => 664,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => "/vagrant-share/conf/idea/idea48.png",
    require => [File["/opt/$idea_name"], User['vagrant'], Group['vagrant']],
  }

  file { "/home/vagrant/Desktop/$idea_name.desktop":
    ensure  => present,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => "/vagrant-share/conf/idea/$idea_name.desktop",
  }

  file { "$idea_config_dir":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => [User['vagrant'], Group['vagrant']],
  }

  file { "$idea_config_dir/config":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$idea_config_dir"],
  }

  file { "$idea_config_dir/config/plugins":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$idea_config_dir/config"],
  }

  file { "$idea_config_dir/config/options":
    ensure  => directory,
    mode    => 775,
    owner   => 'vagrant',
    group   => 'vagrant',
    require => File["$idea_config_dir/config"],
  }

  # Disable IntelliJ IDEA plugins not needed
  file { "$idea_config_dir/config/disabled_plugins.txt":
    ensure  => present,
    mode    => 664,
    owner   => 'vagrant',
    group   => 'vagrant',
    source  => '/vagrant-share/conf/idea/disabled_plugins.txt',
    require => File["$idea_config_dir/config"],
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

  case $jdk {
    'oraclejdk7': {
      file { "${idea_config_dir}/config/options/jdk.table.xml":
        ensure  => present,
        mode    => 664,
        owner   => 'vagrant',
        group   => 'vagrant',
        source  => '/vagrant-share/conf/idea/jdk7.table.xml',
        require => File["${idea_config_dir}/config/options"],
      }
    }
  }
}

