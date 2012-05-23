# Kindle Reader for PC installed using Wine Windows emulator
class apps::kindle {
  include apps::wine
  include apps::xvfb
  include vagrant::user

  $kindle_reader_pc_filename = 'KindleForPC-installer.exe'

  wget::fetch { 'kindle-reader-pc':
    source      => 'http://kindleforpc.amazon.com/38425/KindleForPC-installer.exe', # see http://www.amazon.com/gp/kindle/pc/download
    destination => "/vagrant-share/apps/${kindle_reader_pc_filename}",
  }

  exec { 'install-kindle-reader-wine':
    command   => "/usr/bin/xvfb-run /usr/bin/wine /vagrant-share/apps/${kindle_reader_pc_filename}",
    creates   => "/home/vagrant/.wine/drive_c/Program\ Files\ \(x86\)/Amazon/Kindle/Kindle.exe",
    user      => 'vagrant',
    logoutput => true,
    require   => [Package['xvfb'], Class['apps::wine'], Wget::Fetch['kindle-reader-pc'], User['vagrant']],
  }
}

