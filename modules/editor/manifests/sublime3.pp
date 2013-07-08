class editor::sublime3 {
  include utils::base

  $sublime_build = '3047'
  $sublime_filename = "sublime_text_3_build_${sublime_build}_x64.tar.bz2"
  $sublime_download_dir = '/vagrant-share/apps'
  $sublime_download_file = "${sublime_download_dir}/${sublime_filename}"
  $sublime_install_dir = '/opt/sublime_text_3'

  wget::fetch { 'sublime':
    source      => "http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_${sublime_build}_x64.tar.bz2",
    destination => $sublime_download_file,
  }

  exec { 'extract-sublime':
    command => "/bin/tar -jxf ${sublime_download_file} --directory=/opt",
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

