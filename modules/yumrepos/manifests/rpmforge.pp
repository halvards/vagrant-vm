# Do not use together with EPEL
class yumrepos::rpmforge {
  package { 'rpmforge-release':
    provider => rpm,
    ensure => present,
    source => $kernelrelease ? {
      /el5/ => '/vagrant-share/repos/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm',
      /el6/ => '/vagrant-share/repos/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm',
    },
  }
}

