class debrepos::oabjava7 {
  include debrepos::exclude_recommended
  include utils::base

  if ! defined(Wget::Fetch['oab-java']) {
    wget::fetch { 'oab-java':
      source      => 'https://raw.github.com/flexiondotorg/oab-java6/master/oab-java.sh',
      destination => '/tmp/oab-java.sh',
    }
  }

  exec { 'add-local-oab-java7-apt-repo':
    command   => '/bin/bash /tmp/oab-java.sh -7',
    cwd       => '/tmp',
    creates   => '/var/local/oab/srcs/oracle-java7.git',
    timeout   => 1800, # seconds
    logoutput => true,
    require   => [Wget::Fetch['oab-java'], Class['debrepos::exclude_recommended']],
  }
}

