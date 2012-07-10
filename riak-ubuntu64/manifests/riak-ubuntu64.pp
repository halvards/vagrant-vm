include riak::server
include timezone::sydney
include ubuntu::fixes
include utils::base
#include utils::git

class riak::server {
  $riak_core_version = '1.1.2'

  case $operatingsystem {
    'CentOS': {
      $riak_core_package_filename = ''

      case $kernelrelease {
        /el5/: {
          $riak_core_package_filename = "riak_${riak_core_version}-1.el5.x86_64.rpm"
        }
        /el6/: {
          $riak_core_package_filename = "riak_${riak_core_version}-1.el6.x86_64.rpm"
        }
      }

      wget::fetch { 'riak':
        source      => "http://downloads.basho.com/riak/CURRENT/${riak_core_package_filename}",
        destination => "/vagrant-share/apps/${riak_core_package_filename}",
      }

      package { 'riak':
        provider => rpm,
        ensure   => present,
        source   => "/vagrant-share/apps/${riak_core_package_filename}",
        require  => Wget::Fetch['riak'],
      }
    }
    'Ubuntu': {
      $riak_core_package_filename = "riak_${riak_core_version}-1_amd64.deb"

      wget::fetch { 'riak':
        source      => "http://downloads.basho.com/riak/CURRENT/${riak_core_package_filename}",
        destination => "/vagrant-share/apps/${riak_core_package_filename}",
      }

      package { 'riak':
        provider => dpkg,
        ensure   => present,
        source   => "/vagrant-share/apps/${riak_core_package_filename}",
        require  => [Wget::Fetch['riak'], Package['libssl0.9.8']],
      }

      package { 'libssl0.9.8':
        ensure => present,
      }
    }
  }

  service { 'riak':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['riak'],
  }
}

