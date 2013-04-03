class debrepos::oabjava6 {
  include debrepos::exclude_recommended
  include utils::base

  if ! defined(Wget::Fetch['oab-java']) {
    wget::fetch { 'oab-java':
      source      => 'https://raw.github.com/flexiondotorg/oab-java6/master/oab-java.sh',
      destination => '/tmp/oab-java.sh',
    }
  }

  exec { 'add-local-oab-java6-apt-repo':
    command   => '/bin/bash /tmp/oab-java.sh',
    cwd       => '/tmp',
    creates   => '/var/local/oab/srcs/sun-java6.git',
    timeout   => 1800, # seconds
    logoutput => true,
    require   => [Wget::Fetch['oab-java'], Class['debrepos::exclude_recommended']],
  }
}

