# Utility to install 32 bit libraries on 64 bit Ubuntu
class utils::getlibs {
  if ! defined(Package['ia32-libs']) {
    package { 'ia32-libs':
      ensure => present,
    }
  }

  wget::fetch { 'getlibs':
    source      => 'http://dl.dropbox.com/u/41147122/apps/getlibs-all.deb',
    destination => '/vagrant-share/apps/getlibs-all.deb',
  }

  package { 'getlibs':
    provider => dpkg,
    ensure   => present,
    source   => '/vagrant-share/apps/getlibs-all.deb',
    require  => [Package['ia32-libs'], Wget::Fetch['getlibs']],
  }
}

