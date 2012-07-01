class debrepos::java {
  include utils::base

  $java_apt_repo_file = '/etc/apt/sources.list.d/vagrantvms-java.list'

  exec { 'add-java-apt-repo-key':
    command => "/usr/bin/curl http://dl.dropbox.com/u/41147122/debrepo/java/$lsbdistcodename/pubkey.asc | /usr/bin/apt-key add -",
    unless  => $lsbdistcodename ? {
      'precise' => '/usr/bin/apt-key list | /bin/grep B8343603',
      'oneiric' => '/usr/bin/apt-key list | /bin/grep AC1EFDF7',
      'lucid'   => '/usr/bin/apt-key list | /bin/grep A3033E9E',
    },
    require => Package['curl'],
  }

  exec { 'add-java-apt-repo':
    command => "/bin/echo 'deb http://dl.dropbox.com/u/41147122/debrepo/java/$lsbdistcodename /' >> $java_apt_repo_file && /usr/bin/apt-get update",
    creates => $java_apt_repo_file,
    timeout => 300, # seconds
    tries   => 3, # in case some ppa server is slow
    require => Exec['add-java-apt-repo-key'],
  }
}

