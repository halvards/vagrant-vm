class timezone::sydney {
  case $operatingsystem {
    'Centos': {
      file { '/etc/localtime':
        ensure => link,
        target => '/usr/share/zoneinfo/Australia/Sydney',
        owner => root,
        group => root,
      }
    }
    'Ubuntu': {
      package { ['tzdata', 'ntp']:
        ensure => installed,
      }

      file { '/etc/timezone':
        ensure => present,
        source => '/vagrant-share/conf/timezone-sydney',
        owner => 'root',
        group => 'root',
      }

      exec { 'update-timezone':
        command => '/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata',
        require => [File['/etc/timezone'], Package['tzdata'], Package['ntp']],
      }
    }
  }
}
