include timezone::sydney
include utils::base

#include webdav::server
include openldap::server

class webdav::server {
  include apache::httpd

  file { '/var/www/repo':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode => 775,
    require => Package['httpd'],
  }

  file { '/etc/httpd/conf.d/webdav-apache.conf':
    ensure  => present,
    owner   => 'apache',
    group   => 'apache',
    mode    => 664,
    source  => '/vagrant-share/conf/webdav-apache.conf',
    require => [Package['httpd'], File['/var/www/repo']],
    notify  => Service['httpd'],
  }
}

class openldap::server {
  package { ['openldap', 'openldap-servers', 'openldap-clients', 'nss_ldap']:
    ensure => present,
  }

  exec { 'setup-ldap-db-config':
    command => '/bin/cp /etc/openldap/DB_CONFIG.example /var/lib/ldap/DB_CONFIG',
    creates => '/var/lib/ldap/DB_CONFIG',
    require => Package['openldap', 'openldap-servers', 'openldap-clients', 'nss_ldap'],
  }

  #line::uncomment { 'set-ldap-root-password':
    #line => 'rootpw.*secret',
    #line => 'rootpw.*\{crypt\}ijFYNcSNctBYg',
    #file => '/etc/openldap/slapd.conf',
    #require => Exec['setup-ldap-db-config'],
  #}

  service { 'ldap':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    #require => Line::Uncomment['set-ldap-root-password'],
    require => Exec['setup-ldap-db-config'],
  }

}

