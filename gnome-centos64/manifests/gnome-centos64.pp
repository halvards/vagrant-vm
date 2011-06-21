class wm::gnome {
  package { ['gnome-session', 'system-config-display', 'xorg-x11-xinit', 'gdm', 'dbus-x11', 'gnome-applets', 'gnome-terminal', 'nautilus', 'gedit']:
    ensure => present,
  }
}

class google::chrome {
  include repos::google64

  package { 'google-chrome-stable':
    ensure => latest,
    require => Yumrepo['google64'],
  }
}

class utils::base {
  package { ['bash', 'wget', 'curl', 'patch', 'unzip', 'sed', 'tar', 'gzip', 'bzip2', 'man']:
    ensure => present,
  }
}

class utils::vcs {
  include repos::epel

  package { 'mercurial':
    ensure => present,
    require => Package['epel-release'],
  }
}

class repos::epel {
  package { 'epel-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/epel-release-5-4.noarch.rpm',
  }
}

class repos::elff {
  package { 'elff-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/elff-release-5-3.noarch.rpm',
  }
}

class repos::jpackage {
  package { ['jpackage-utils', 'yum-priorities']:
    ensure => present,
  }

  package { 'jpackage-release':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/jpackage-release-5-4.jpp5.noarch.rpm',
    require => [Package['jpackage-utils'], Package['yum-priorities']],
  }
}

class repos::google64 {
  yumrepo { 'google64':
    descr => 'Google RPM Repository 64 bit',
    baseurl => 'http://dl.google.com/linux/rpm/stable/x86_64',
    enabled => 1,
    gpgcheck => 1,
    gpgkey => 'https://dl-ssl.google.com/linux/linux_signing_key.pub',
  }
}

include repos::jpackage
include utils::base
include utils::vcs
include wm::gnome
include google::chrome

