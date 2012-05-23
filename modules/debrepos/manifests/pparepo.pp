# Setup a PPA repo, where the name is "user/ppaname", e.g. "blueyed/ppa" ("ppa" being the default)
#
# Example usage:
# debrepos::pparepo { 'nilarimogard/webupd8':
#   apt_key => '4C9D234C',
# }
#
define debrepos::pparepo($apt_key = "", $dist = $ppa_default_name, $ensure = present, $keyserver = "keyserver.ubuntu.com") {
  $name_for_file = regsubst($name, '/', '-', 'G')
  $file = "/etc/apt/sources.list.d/pparepo-${name_for_file}.list"
  file { "$file": }

  case $ensure {
    present: {
      File["$file"] {
        content => "deb http://ppa.launchpad.net/$name/ubuntu $lsbdistcodename main\ndeb-src http://ppa.launchpad.net/$name/ubuntu $lsbdistcodename main\n"
      }
      File["$file"] { ensure => file }
      if ( $apt_key ) {
        if ! defined(Debrepos::Aptkey["$apt_key"]) {
          debrepos::aptkey { "$apt_key": }
        }
      }
      exec { "update-apt-${name_for_file}":
        command => "/usr/bin/apt-get update && /usr/bin/touch /etc/apt/pparepo-${name_for_file}.updated",
        creates => "/etc/apt/pparepo-${name_for_file}.updated",
        require => [File["$file"], Debrepos::Aptkey["$apt_key"]],
      }
    }
    absent:  {
      File["$file"] { ensure => false }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for pparepo"
    }
  }
}

