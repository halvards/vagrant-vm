# Simple Twitter client
class apps::gwibber {
  package { ['gwibber', 'python-httplib2']:
    ensure  => present,
  }
}

