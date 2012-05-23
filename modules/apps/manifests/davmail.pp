class apps::davmail {
  include java::sunjdk6

  $davmail_major_version = '3.9.8'
  $davmail_version       = "${davmail_major_version}-1921-1"
  $davmail_filename      = "davmail_${davmail_version}_all.deb"

  wget::fetch { 'davmail':
    source      => "http://aarnet.dl.sourceforge.net/project/davmail/davmail/${davmail_major_version}/davmail_${davmail_version}_all.deb",
    destination => "/vagrant-share/apps/${davmail_filename}",
  }

  package { ['libswt-gtk-3-jni', 'libswt-gtk-3-java']:
    ensure  => present,
    require => Package['sun-java6-jdk'],
  }

  package { 'davmail':
    provider => dpkg,
    ensure   => present,
    source   => "/vagrant-share/apps/${davmail_filename}",
    require  => [Package['libswt-gtk-3-jni', 'libswt-gtk-3-java'], Wget::Fetch['davmail']],
  }

  exec { 'show-davmail-in-systray':
    command => "/usr/bin/gsettings set com.canonical.Unity.Panel systray-whitelist \"['JavaEmbeddedFrame', 'Wine', 'Update-notifier', 'SWT']\"",
    unless  => "/usr/bin/gsettings get com.canonical.Unity.Panel systray-whitelist | /bin/grep 'SWT'",
    logoutput => true,
  }
}

