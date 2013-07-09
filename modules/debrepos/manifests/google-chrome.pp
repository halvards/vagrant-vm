# http://www.google.com/linuxrepositories/
class debrepos::google-chrome {
  $google_chrome_apt_repo_file = '/etc/apt/sources.list.d/google-chrome.list'

  debrepos::aptkey { '7FAC5991': }

  exec { 'add-google-chrome-apt-repo':
    command => "/bin/echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> $google_chrome_apt_repo_file && /usr/bin/apt-get update",
    creates => $google_chrome_apt_repo_file,
    timeout => 300, # seconds
    tries   => 3, # in case some ppa server is slow
    require => Debrepos::Aptkey['7FAC5991'],
  }
}

