class vcs::git {
  if ! defined(Package['git']) {
    package { 'git':
      ensure => present,
    }
  }
}

