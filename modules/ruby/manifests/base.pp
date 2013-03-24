class ruby::base {
  case $operatingsystem {
    'CentOS': {
      package { ['ruby', 'ruby-irb', 'rubygems', 'rubygem-rake']:
        ensure => present,
      }
    }
    'Ubuntu': {
      package { ['ruby', 'irb', 'rubygems', 'rake']:
        ensure => present,
      }
    }
  }

}

