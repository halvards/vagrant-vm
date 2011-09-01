include timezone::sydney
include utils::base

include webdav::server
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

  file { '/var/www/repo/public':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode => 775,
    require => File['/var/www/repo'],
  }

  file { '/var/www/repo/secret':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode => 770,
    require => File['/var/www/repo'],
  }

  file { '/etc/httpd/auth':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode => 770,
    require => Package['httpd'],
  }

  file { '/etc/httpd/auth/webdav-basic-passwords':
    ensure => present,
    owner => 'apache',
    group => 'apache',
    mode => 660,
    source => '/vagrant-share/conf/webdav-basic-passwords',
    require => File['/etc/httpd/auth'],
  }

  file { '/etc/httpd/conf.d/200-webdav-apache.conf':
    ensure  => present,
    owner   => 'apache',
    group   => 'apache',
    mode    => 664,
    source  => '/vagrant-share/conf/webdav-apache-ldap-auth.conf',
    require => [Package['httpd'], File['/var/www/repo', '/etc/httpd/auth/webdav-basic-passwords']],
    notify  => Service['httpd'],
  }
}

# From http://www.3open.org/d/ldap/setup_openldap_directory_on_centos_5
class openldap::server {
  include iptables::disable

  group { 'ldap':
    ensure  => present,
  }

  user { 'ldap':
    comment => 'LDAP user',
    gid => 'ldap',
    home => '/var/lib/ldap',
    managehome => true,
    shell => '/bin/false',
    require => Group['ldap'],
  }

  vagrant::group { 'vagrant-ldap':
    group => 'ldap',
  }

  package { ['openldap', 'openldap-servers', 'openldap-clients', 'nss_ldap']:
    ensure => present,
    require => User['ldap'],
  }

  exec { 'setup-ldap-db-config':
    command => '/bin/cp /etc/openldap/DB_CONFIG.example /var/lib/ldap/DB_CONFIG',
    creates => '/var/lib/ldap/DB_CONFIG',
    require => Package['openldap', 'openldap-servers', 'openldap-clients', 'nss_ldap'],
  }

  file { '/etc/openldap/slapd.conf':
    ensure => present,
    owner   => 'root',
    group   => 'ldap',
    mode    => 640,
    source  => '/vagrant-share/conf/ldap/slapd.conf',
    require => Package['openldap', 'openldap-servers', 'openldap-clients', 'nss_ldap'],
  }

  service { 'ldap':
    enable => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => [Exec['setup-ldap-db-config'], File['/etc/openldap/slapd.conf']],
  }

  $ldapadd_cmd = '/usr/bin/ldapadd -D "cn=admin,dc=example,dc=com" -x -w secret -f '
  $ldap_schema_dir = '/vagrant-share/conf/ldap'
  $ldapsearch_cmd = "/usr/bin/ldapsearch -xLLL -b 'dc=example,dc=com'"

  # Retries since something takes time - either starting ldap service or disabling selinux
  exec { 'create-ldap-root-object':
    command => "$ldapadd_cmd $ldap_schema_dir/root-organisation-object.ldif",
    logoutput => true,
    returns => [0, 68],
    tries => 5,
    try_sleep => 1, # seconds
    require => Service['ldap'],
  }

  exec { 'create-ldap-admin':
    command => "$ldapadd_cmd $ldap_schema_dir/directory-admin-object.ldif",
    logoutput => true,
    returns => [0, 68],
    require => Exec['create-ldap-root-object'],
  }

  exec { 'create-ldap-user-alice':
    command => "$ldapadd_cmd $ldap_schema_dir/regular-user-object-alice.ldif",
    logoutput => true,
    returns => [0, 68],
    require => Exec['create-ldap-admin'],
  }

  exec { 'create-ldap-user-bob':
    command => "$ldapadd_cmd $ldap_schema_dir/regular-user-object-bob.ldif",
    logoutput => true,
    returns => [0, 68],
    require => Exec['create-ldap-admin'],
  }
}

