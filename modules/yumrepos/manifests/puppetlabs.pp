# Do not use together with RPMForge
class yumrepos::puppetlabs {
  package { 'puppetlabs-release':
    provider => rpm,
    ensure => present,
    source => $kernelrelease ? {
      /el5/ => '/vagrant-share/repos/puppetlabs-release-5-1.noarch.rpm',
      /el6/ => '/vagrant-share/repos/puppetlabs-release-6-1.noarch.rpm',
    },
  }
}

