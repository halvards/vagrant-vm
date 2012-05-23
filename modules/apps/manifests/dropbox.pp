class apps::dropbox {
  $dropbox_client_version  = '1.4.0'
  $dropbox_client_filename = "dropbox_${dropbox_client_version}_amd64.deb"

  wget::fetch { 'dropbox-client':
    source      => "http://linux.dropbox.com/packages/ubuntu/dropbox_${dropbox_client_version}_amd64.deb",
    destination => "/vagrant-share/apps/${dropbox_client_filename}",
  }

  package { 'dropbox':
    provider => dpkg,
    ensure   => present,
    source   => "/vagrant-share/apps/${dropbox_client_filename}",
    require  => Wget::Fetch['dropbox-client'],
  }
}

