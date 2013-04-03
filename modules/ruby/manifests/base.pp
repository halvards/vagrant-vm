class ruby::base {
  case $operatingsystem {
    'CentOS': {
      package { ['ruby', 'ruby-irb', 'rubygems', 'rubygem-rake']:
        ensure => present,
      }
    }
    'Ubuntu': {
      package { ['ruby', 'rubygems', 'rake']:
        ensure => present,
      }
    }
  }

}

