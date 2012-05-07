class utils::mercurial {
  if ! defined(Package['mercurial']) {
    package { 'mercurial':
      ensure => present,
    }
  }
}

