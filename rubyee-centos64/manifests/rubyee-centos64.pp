include ruby::passenger
include timezone::sydney

class ruby::passenger {
  include ruby::enterprise

  package { 'httpd':
    ensure => present,
  }

  package { ['gcc-c++', 'curl-devel', 'openssl-devel', 'zlib-devel', 'httpd-devel', 'apr-devel', 'apr-util-devel']:
    ensure => present,
  }

  package { 'passenger':
    provider => gem,
    ensure => present,
    require => [Package['ruby-enterprise-rubygems'], File['/usr/local/bin/ri'], File['/usr/local/bin/ruby'], File['/usr/local/bin/gem']],
  }

  exec { '/opt/ruby-enterprise/bin/passenger-install-apache2-module --auto':
    creates => '/opt/ruby-enterprise/lib/ruby/gems/1.8/gems/passenger-3.0.7/ext/apache2/mod_passenger.so',
    require => [Package['gcc-c++'], Package['curl-devel'], Package['openssl-devel'], Package['zlib-devel'], Package['httpd-devel'], Package['apr-devel'], Package['apr-util-devel']],
  }
}

class ruby::enterprise {
  include yumrepos::rubyee

  package { ['ruby-enterprise', 'ruby-enterprise-rubygems']:
    ensure => present,
    require => Package['ruby-enterprise-opt-repo'],
  }

  file { '/usr/local/bin/erb':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/erb',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/irb':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/irb',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/rdoc':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/rdoc',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/ree-version':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/ree-version',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/ri':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/ri',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/ruby':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/ruby',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/testrb':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/testrb',
    require => Package['ruby-enterprise'],
  }

  file { '/usr/local/bin/gem':
    ensure => link,
    target => '/opt/ruby-enterprise/bin/gem',
    require => Package['ruby-enterprise-rubygems'],
  }
}

