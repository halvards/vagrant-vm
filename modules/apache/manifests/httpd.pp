class apache::httpd {
  group { 'apache':
    ensure  => present,
  }

  user { 'apache':
    comment => 'Apache httpd server user',
    gid => 'apache',
    home => '/var/www',
    managehome => true,
    shell => '/bin/false',
    require => Group['apache'],
  }

  vagrant::group { 'vagrant-apache':
    group => 'apache',
  }

  package { ['httpd', 'mod_ssl']:
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

