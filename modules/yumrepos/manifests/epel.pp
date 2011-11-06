# Do not use together with RPMForge
class yumrepos::epel {
  package { 'epel-release':
    provider => rpm,
    ensure => present,
    source => $kernelrelease ? {
      /el5/ => '/vagrant-share/repos/epel-release-5-4.noarch.rpm',
      /el6/ => '/vagrant-share/repos/epel-release-6-5.noarch.rpm',
    },
  }
}

