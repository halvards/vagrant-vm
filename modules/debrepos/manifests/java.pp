class debrepos::java {
  include utils::base

  $apt_repo_file = '/etc/apt/sources.list.d/vagrantvms-java.list'

  exec { 'add-java-apt-repo-key':
    command => "/usr/bin/curl http://dl.dropbox.com/u/41147122/debrepo/java/$lsbdistcodename/pubkey.asc | /usr/bin/apt-key add -",
    require => Package['curl'],
  }

  exec { 'add-java-apt-repo':
    command => "/bin/echo 'deb http://dl.dropbox.com/u/41147122/debrepo/java/$lsbdistcodename /' >> $apt_repo_file && /usr/bin/apt-get update",
    creates => $apt_repo_file,
    require => Exec['add-java-apt-repo-key'],
  }
}

