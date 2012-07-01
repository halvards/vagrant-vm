class utils::pip {
  case $operatingsystem {
    'CentOS': {
      include yumrepos::epel

      package { 'python':
        ensure => present,
      }

      package { ['python-devel', 'python-docutils']:
        ensure  => present,
        require => Package['python'],
      }

      package { 'python-pip':
        ensure  => present,
        require => Package['epel-release', 'python'],
      }

      file { '/usr/bin/pip':
        ensure  => link,
        target  => '/usr/bin/pip-python',
        require => Package['python-pip'],
      }
    }
    'Ubuntu': {
      package { ['python-dev', 'python-docutils']:
        ensure  => present,
        require => Package['python'],
      }

      package { 'python-pip':
        ensure  => present,
        require => Package['python'],
      }
    }
  }
}

