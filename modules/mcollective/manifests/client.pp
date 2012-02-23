class mcollective::client {
  include yumrepos::puppetlabs

  package { ['mcollective', 'mcollective-client']:
    ensure => present,
  }

  line::commentout { 'mcollective-server-port-61613':
    line    => 'plugin.stomp.port = 61613',
    file    => '/etc/mcollective/server.cfg',
    require => Package['mcollective'],
  }

  line::present { 'mcollective-server-port-6163':
    line    => 'plugin.stomp.port = 6163',
    file    => '/etc/mcollective/server.cfg',
    require => Package['mcollective'],
  }

  line::commentout { 'mcollective-client-port-61613':
    line    => 'plugin.stomp.port = 61613',
    file    => '/etc/mcollective/client.cfg',
    require => Package['mcollective-client'],
  }

  line::present { 'mcollective-client-port-6163':
    line    => 'plugin.stomp.port = 6163',
    file    => '/etc/mcollective/client.cfg',
    require => Package['mcollective-client'],
  }
}

