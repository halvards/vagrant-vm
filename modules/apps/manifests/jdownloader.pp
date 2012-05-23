class apps::jdownloader {
  include java::sunjdk6

  debrepos::pparepo { 'jd-team/jdownloader':
    apt_key => '6A68F637',
  }

  package { 'jdownloader':
    ensure  => present,
    require => [Package['sun-java6-jdk'], Debrepos::Pparepo['jd-team/jdownloader']],
  }
}

