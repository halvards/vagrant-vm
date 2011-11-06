class oracle::sqldeveloper {
  include repos::vagrantvms

  package { 'sqldeveloper':
    ensure => present,
    require => Yumrepo['vagrantvms'],
  }
}

