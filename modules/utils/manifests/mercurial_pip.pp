class utils::mercurial_pip {
  package { 'python':
    ensure => present,
  }

  package { 'python-docutils':
    ensure => present,
    require => Package['python'],
  }

  package { 'mercurial_keyring':
    provider => pip,
    ensure => present,
    require => Package['keyring', 'mercurial'],
  }

  case $operatingsystem {
    'CentOS': {
      include yumrepos::epel

      package { 'python-devel':
        ensure => present,
        require => Package['python'],
      }

      package { 'python-pip':
        ensure => present,
        require => Package['epel-release', 'python'],
      }

      file { '/usr/bin/pip':
        ensure => link,
        target => '/usr/bin/pip-python',
        require => Package['python-pip'],
      }

      package { 'mercurial':
        provider => pip,
        ensure => present,
        require => [File['/usr/bin/pip'], Package['python-devel', 'python-docutils']],
      }

      package { 'keyring':
        provider => pip,
        ensure => present,
        require => File['/usr/bin/pip'],
      }

      file { '/home/vagrant/.hgrc':
        ensure => present,
        source => '/vagrant-share/apps/hgrc',
        require => Package['mercurial_keyring'],
      }
    }
    'Ubuntu': {
      package { 'python-dev':
        ensure => present,
        require => Package['python'],
      }

      package { 'python-pip':
        ensure => present,
        require => Package['python'],
      }

      package { 'mercurial':
        provider => pip,
        ensure => present,
        require => Package['python-dev', 'python-docutils', 'python-pip'],
      }

      package { 'keyring':
        provider => pip,
        ensure => present,
        require => Package['python-pip'],
      }
    }
  }
}

