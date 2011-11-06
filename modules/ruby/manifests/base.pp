class ruby::base {
  package { ['ruby', 'ruby-irb', 'rubygems', 'rubygem-rake']:
    ensure => present,
  }
}

