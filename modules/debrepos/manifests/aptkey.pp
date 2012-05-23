# source http://projects.puppetlabs.com/projects/1/wiki/Apt_Keys_Patterns
define debrepos::aptkey($ensure = present, $keyserver = "keyserver.ubuntu.com") {
  $grep_for_key = "apt-key list | grep '^pub' | sed -r 's.^pub\\s+\\w+/..' | grep '^$name'"
  case $ensure {
    present: {
      exec { "Import $name to apt keystore":
        path        => "/bin:/usr/bin",
        environment => "HOME=/root",
        command     => "gpg --keyserver $keyserver --recv-keys $name && gpg --export --armor $name | apt-key add -",
        user        => "root",
        group       => "root",
        unless      => "$grep_for_key",
        logoutput   => on_failure,
      }
    }
    absent:  {
      exec { "Remove $name from apt keystore":
        path    => "/bin:/usr/bin",
        environment => "HOME=/root",
        command => "apt-key del $name",
        user    => "root",
        group   => "root",
        onlyif  => "$grep_for_key",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}

