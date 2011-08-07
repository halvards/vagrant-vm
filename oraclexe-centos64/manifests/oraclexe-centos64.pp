include oracle::xe
include timezone::sydney

class oracle::xe {
  include utils::base
  include partition::swap2gb

  $oraclexe_zipfile = '/vagrant-share/apps/linux.x64_11gR2_OracleXE.zip'
  $oraclexe_unzip_location = '/vagrant-share/apps/oraclexe'
  $oraclexe_rpmfile = "$oraclexe_unzip_location/oracle-xe-11.2.0-0.5.x86_64.rpm"

  # Needs oracle.com login to download - copy this link and save to share/apps
  wget::fetch { 'oracle-xe':
    source => 'http://download.oracle.com/otn/beta/xe/linux.x64_11gR2_OracleXE.zip',
    destination => $oraclexe_zipfile,
  }

  exec { 'extract-oracle-xe-rpm':
    command => "/usr/bin/unzip $oraclexe_zipfile -d $oraclexe_unzip_location",
    creates => $oraclexe_rpmfile,
    require => [Wget::Fetch['oracle-xe'], Package['tar', 'gzip']],
  }

  package { 'oracle-xe':
    provider => rpm,
    ensure => present,
    source => $oraclexe_rpmfile,
    require => Exec['extract-oracle-xe-rpm'],
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
}

class partition::swap2gb {
  exec { 'increase-swap':
    command => '/bin/bash /vagrant-share/conf/create-swap-file.sh',
    unless => "/bin/grep --quiet 'swapfile' /etc/fstab",
    logoutput => true,
  }
}

