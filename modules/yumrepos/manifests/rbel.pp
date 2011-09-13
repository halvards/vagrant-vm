class yumrepos::rbel {
  package { 'rbel-release':
    provider => rpm,
    ensure => present,
    source => $kernelrelease ? {
      /el5/ => '/vagrant-share/repos/rbel5-release-1.0-2.el5.noarch.rpm',
      /el6/ => '/vagrant-share/repos/rbel6-release-1.0-2.el6.noarch.rpm',
    },
  }
}

