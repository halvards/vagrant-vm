class apps::thunderbird {
  package { ['thunderbird',
             'thunderbird-globalmenu',
             'thunderbird-gnome-support',
             'xul-ext-calendar-timezones',
             'xul-ext-gdata-provider',
             'xul-ext-lightning']:
    ensure => present,
  }
}

