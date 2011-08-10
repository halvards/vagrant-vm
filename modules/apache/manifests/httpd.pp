class apache::httpd {
  group { 'apache':
    ensure  => present,
  }

  user { 'apache':
    comment => 'Apache httpd server user',
    gid => 'apache',
    home => '/home/apache',
    managehome => true,
    shell => '/bin/bash',
    require => Group['apache'],
  }

  user { 'vagrant':
    ensure => present,
    groups => 'apache',
    membership => minimum,
    require => Group['apache'],
  }

  package { 'httpd':
    ensure => present,
    require => User['apache'],
  }

  service { 'httpd':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['httpd'],
  }
}

