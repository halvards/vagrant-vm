class apps::transmission {
  package { ['transmission-gtk', 'transmission-cli']:
    ensure => present,
  }
}

