class editor::sublime {
  include utils::base

  $sublime_version = '2.0.2'
  $sublime_filename = "SublimeText${sublime_version}.tar.bz2"
  $sublime_download_dir = '/vagrant-share/apps'
  $sublime_download_file = "${sublime_download_dir}/${sublime_filename}"
  $sublime_install_dir = '/opt/SublimeText2'

  wget::fetch { 'sublime':
    source      => "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20${sublime_version}%20x64.tar.bz2",
    destination => $sublime_download_file,
  }

  exec { 'extract-sublime':
    command => "/bin/tar -jxf ${sublime_download_file} --directory=/opt && /bin/mv '/opt/Sublime Text 2' ${sublime_install_dir}",
    creates => $sublime_install_dir,
    require => [Wget::Fetch['sublime'], Package['tar', 'bzip2']],
  }

  file { '/usr/local/bin/sublime_text':
    ensure  => link,
    target  => "${sublime_install_dir}/sublime_text",
    require => Exec['extract-sublime'],
  }

  file { '/usr/local/bin/subl':
    ensure  => link,
    target  => "${sublime_install_dir}/sublime_text",
    require => Exec['extract-sublime'],
  }
}

