class mercurial::server {
  include apache::httpd
  include utils::mercurial

  file { '/opt':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => 755,
  }

  file { '/opt/hg':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode => 755,
    require => File['/opt'],
  }

  file { '/opt/hg/repo':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode => 755,
    require => File['/opt/hg'],
  }
  file { '/opt/hg/index.cgi':
    ensure => present,
    owner => 'apache',
    group => 'apache',
    mode => 755,
    source => '/vagrant-share/conf/mercurial/index.cgi',
    require => [Package['python'], File['/opt/hg/repo']],
  }

  file { '/opt/hg/hgweb.config':
    ensure => present,
    owner => 'apache',
    group => 'apache',
    mode => 755,
    source => '/vagrant-share/conf/mercurial/hgweb.config',
    require => File['/opt/hg'],
  }

  exec { 'change-selinux-security-context':
    command => '/usr/bin/chcon -t httpd_sys_script_exec_t hgweb.config index.cgi',
    cwd => '/opt/hg',
    require => [Package['mercurial'], File['/opt/hg/index.cgi', '/opt/hg/hgweb.config']],
  }

  file { '/etc/httpd/conf.d/mercurial.conf':
    ensure  => present,
    owner => 'root',
    group => 'root',
    mode => 644,
    source  => '/vagrant-share/conf/mercurial/mercurial.conf',
    require => [Package['httpd'], Exec['change-selinux-security-context']],
    notify => Service['httpd'],
  }
}

