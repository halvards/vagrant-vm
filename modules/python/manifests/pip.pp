class python::pip {
  include python::base

  case $operatingsystem {
    'CentOS': {
      include yumrepos::epel

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
      package { ['build-essential', 'python-dev', 'python-docutils']:
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

