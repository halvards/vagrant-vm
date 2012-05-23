class debrepos::medibuntu {
  $medibuntu_apt_repo_file = '/etc/apt/sources.list.d/medibuntu.list'

  debrepos::aptkey { '0C5A2783': }

  exec { 'add-medibuntu-apt-repo':
    command => "/bin/echo 'deb http://packages.medibuntu.org/ $lsbdistcodename free non-free' >> $medibuntu_apt_repo_file && /usr/bin/apt-get update",
    creates => $medibuntu_apt_repo_file,
    require => Debrepos::Aptkey['0C5A2783'],
  }
}

