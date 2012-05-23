# Twitter client, currently in alpha
class apps::hotot {
  debrepos::pparepo { 'hotot-team':
    apt_key => '41011AE2',
  }

  package { 'hotot':
    ensure  => present,
    require => Debrepos::Pparepo['hotot-team'],
  }
}

