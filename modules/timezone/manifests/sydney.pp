class timezone::sydney {
  case $operatingsystem {
    'Centos': {
      file { '/etc/localtime':
        ensure => link,
        force  => true,
        group  => 'root',
        owner  => 'root',
        target => '/usr/share/zoneinfo/Australia/Sydney',
      }
    }
    'Ubuntu': {
      package { ['tzdata', 'ntp']:
        ensure => installed,
      }

      file { '/etc/timezone':
        ensure => present,
        group  => 'root',
        owner  => 'root',
        source => '/vagrant-share/conf/timezone-sydney',
      }

      exec { 'update-timezone':
        command => '/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata',
        require => [File['/etc/timezone'], Package['tzdata', 'ntp']],
      }
    }
  }
}
