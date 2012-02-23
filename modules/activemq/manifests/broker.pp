class activemq::broker {
  include yumrepos::puppetlabs

  package { 'tanukiwrapper':
    ensure  => present,
    require => Package['puppetlabs-release'],
  }

  package { 'activemq':
    ensure  => $activemq_version,
    require => Package['puppetlabs-release'],
  }

  group { 'activemq':
    ensure    => present,
    allowdupe => false,
    require   => Package['activemq'],
  }

  user { 'activemq':
    ensure  => present,
    require => Group['activemq'],
  }

  vagrant::group { 'vagrant-activemq':
    group   => 'activemq',
    require => Group['activemq'],
  }

  package { 'activemq-info-provider':
    ensure  => $activemq_version,
    require => Package['activemq'],
  }

  service { "activemq":
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['activemq', 'activemq-info-provider', 'tanukiwrapper'],
  }
}

