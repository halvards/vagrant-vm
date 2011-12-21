class apache::httpd {
  package { ['httpd', 'mod_ssl']:
    ensure => present,
  }

  group { 'apache':
    ensure  => present,
    require => Package['httpd'],
  }

  user { 'apache':
    ensure => present,
    require => Group['apache'],
  }

  vagrant::group { 'vagrant-apache':
    group => 'apache',
    require => Group['apache'],
  }

  service { 'httpd':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package['httpd'],
  }

  file { '/var/log/httpd':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => 0755,
    require => Package['httpd'],
  }
}

