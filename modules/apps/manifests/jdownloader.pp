class apps::jdownloader {
  include java::oraclejdk7

  debrepos::pparepo { 'jd-team/jdownloader':
    apt_key => '6A68F637',
  }

  package { 'jdownloader':
    ensure  => present,
    require => [Class['java::oraclejdk7'], Debrepos::Pparepo['jd-team/jdownloader']],
  }
}

