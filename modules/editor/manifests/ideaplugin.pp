define editor::ideaplugin($version, $filetype, $update_id, $idea_edition = 'IU') {
  $idea_config_dir = $idea_edition ? {
    'IC' => '/home/vagrant/.IdeaIC12',
    'IU' => '/home/vagrant/.IntelliJIdea12',
  }
  $idea_plugins_dir = "${idea_config_dir}/config/plugins"

  $plugin_download_dir = '/vagrant-share/apps'
  $plugin_filename = "${name}-${version}.${filetype}"
  $plugin_file_path = "${plugin_download_dir}/${plugin_filename}"

  wget::fetch { "ideaplugin-${name}":
    source      => "http://plugins.jetbrains.com/plugin/download?updateId=${update_id}",
    destination => $plugin_file_path,
  }

  case $filetype {
    'zip': {
      exec { "extract-ideaplugin-${name}":
        command => "/usr/bin/unzip ${plugin_file_path} -d ${idea_plugins_dir}",
        creates => "$idea_config_dir/config/plugins/ruby",
        require => [Wget::Fetch["ideaplugin-${name}"], File["${idea_plugins_dir}"], Package['unzip']],
      }
    }
    'jar': {
      file { "${idea_plugins_dir}/${name}.${filetype}":
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

