class apache::httpd {
  case $operatingsystem {
    'CentOS': {
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
    'Ubuntu': {
      package { ['apache2']:
        ensure => present,
      }

      group { 'www-data':
        ensure  => present,
        require => Package['apache2'],
      }

      user { 'www-data':
        ensure => present,
        require => Group['www-data'],
      }

      vagrant::group { 'vagrant-www-data':
        group => 'www-data',
        require => Group['www-data'],
      }

      service { 'apache2':
        enable => true,
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => Package['apache2'],
      }

    }
  }
}
