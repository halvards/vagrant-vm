class editor::eclipse($jdk = 'oraclejdk7') {
  if ! defined(Class["java::$jdk"]) {
    class { "java::$jdk": }
  }

  package { ['eclipse', 'eclipse-egit']:
    ensure  => present,
    require => Class["java::$jdk"],
  }
}

