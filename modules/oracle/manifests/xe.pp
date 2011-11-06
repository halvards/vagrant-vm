class oracle::xe {
  include utils::base
  include repos::vagrantvms
  include partition::swap2gb

  line::commentout { 'commentout-net_bridge_bridge-nf-call-ip6tables':
    line => 'net.bridge.bridge-nf-call-ip6tables',
    file => '/etc/sysctl.conf',
  }

  line::commentout { 'commentout-net_bridge_bridge-nf-call-iptables':
    line => 'net.bridge.bridge-nf-call-iptables',
    file => '/etc/sysctl.conf',
  }

  line::commentout { 'commentout-net_bridge_bridge-nf-call-arptables':
    line => 'net.bridge.bridge-nf-call-arptables',
    file => '/etc/sysctl.conf',
  }

  package { 'oracle-xe':
    ensure => present,
    require => [Yumrepo['vagrantvms'], Line::Commentout['commentout-net_bridge_bridge-nf-call-ip6tables',
                                                        'commentout-net_bridge_bridge-nf-call-iptables',
                                                        'commentout-net_bridge_bridge-nf-call-arptables']],
  }

  exec { 'setup-oracle-xe':
    command => '/etc/init.d/oracle-xe configure responseFile=/vagrant-share/conf/oraclexe.response > /tmp/XEsilentinstall.log',
    creates => '/tmp/XEsilentinstall.log',
    logoutput => true,
    timeout => 600, #seconds
    require => [Package['oracle-xe'], Exec['increase-swap']],
  }

  exec { 'setup-user-env':
    command => "/bin/echo 'source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh' >> /home/vagrant/.bashrc",
    unless => "/bin/grep --quiet 'oracle_env' /home/vagrant/.bashrc",
    require => Exec['setup-oracle-xe'],
  }

  exec { 'setup-root-env':
  	command => "/bin/echo 'source /u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh' >> /root/.bashrc",
    unless => "/bin/grep --quiet 'oracle_env' /root/.bashrc",
    require => Exec['setup-user-env'],
  }

  exec { 'create-oracle-user':
    command => "/bin/bash /vagrant-share/conf/create-oracle-user.sh",
    cwd => "/vagrant-share/conf",
    logoutput => true,
    require => Exec['setup-root-env']
  }
}

