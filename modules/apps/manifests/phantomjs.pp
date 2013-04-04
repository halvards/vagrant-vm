class apps::phantomjs {
  include utils::base

  $phantomjs_version = '1.9.0'
  $phantomjs_name = "phantomjs-${phantomjs_version}-linux-x86_64"
  $phantomjs_filename = "${phantomjs_name}.tar.bz2"
  $phantomjs_download_dir = '/vagrant-share/apps'
  $phantomjs_download_file = "${phantomjs_download_dir}/${phantomjs_filename}"

  wget::fetch { 'phantomjs':
    source      => "https://phantomjs.googlecode.com/files/${phantomjs_filename}",
    destination => $phantomjs_download_file,
  }

  exec { 'extract-phantomjs':
    command => "/bin/tar -jxf ${phantomjs_download_file} --directory=/opt",
    creates => "/opt/${phantomjs_name}",
    require => [Wget::Fetch['phantomjs'], Package['tar', 'bzip2']],
  }

  file { '/usr/local/share/phantomjs':
    ensure  => link,
    target  => "/opt/${phantomjs_name}",
    require => Exec['extract-phantomjs'],
  }

  file { '/usr/local/bin/phantomjs':
    ensure  => link,
    target  => "/usr/local/share/phantomjs/bin/phantomjs",
    require => File['/usr/local/share/phantomjs'],
  }
}

