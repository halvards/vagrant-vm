define editor::ideaplugin($plugin_name, $version, $filetype, $update_id, $idea_edition) {
  include vagrant::user

  $idea_config_dir = $idea_edition ? {
    'IC'       => '/home/vagrant/.IdeaIC12',
    'IU'       => '/home/vagrant/.IntelliJIdea12',
    'PyCharm'  => '/home/vagrant/.PyCharm20',
    'RubyMine' => '/home/vagrant/.RubyMine50',
    'WebStorm' => '/home/vagrant/.WebStorm6',
  }
  $idea_plugins_dir = "${idea_config_dir}/config/plugins"

  $plugin_download_dir = '/vagrant-share/apps'
  $plugin_filename = "${plugin_name}-${version}.${filetype}"
  $plugin_file_path = "${plugin_download_dir}/${plugin_filename}"

  wget::fetch { "ideaplugin-${name}":
    source      => "http://plugins.jetbrains.com/plugin/download?updateId=${update_id}",
    destination => $plugin_file_path,
  }

  case $filetype {
    'zip': {
      exec { "extract-ideaplugin-${name}":
        command => "/usr/bin/unzip ${plugin_file_path} -d ${idea_plugins_dir}",
        creates => "${idea_config_dir}/config/plugins/${plugin_name}",
        user    => 'vagrant',
        require => [Wget::Fetch["ideaplugin-${name}"], File["${idea_plugins_dir}"], Package['unzip'], User['vagrant']],
      }
    }
    'jar': {
      file { "${idea_plugins_dir}/${plugin_name}.${filetype}":
        ensure  => present,
        source  => $plugin_file_path,
        require => [Wget::Fetch["ideaplugin-${name}"], File["${idea_plugins_dir}"]],
      }
    }
    default: {
      fail "Invalid 'filetype' value '${filetype}' for ideaplugin"
    }
  }
}

