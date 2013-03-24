class apps::handbrake {
  debrepos::pparepo { 'stebbins/handbrake-releases':
    apt_key => '816950D8',
  }

  package { ['handbrake-cli', 'handbrake-gtk']:
    ensure  => present,
    require => Debrepos::Pparepo['stebbins/handbrake-releases'],
  }
}


