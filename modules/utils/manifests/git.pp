class utils::git {
  if ! defined(Package['git']) {
    case $operatingsystem {
      'CentOS': {
        package { 'git':
          ensure => present,
        }
      }
      'Ubuntu': {
        package { 'git':
          ensure => present,
          name => 'git-core',
        }
      }
    }
  }
}

