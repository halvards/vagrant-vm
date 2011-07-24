class utils::base {
  package { ['coreutils', 'bash', 'wget', 'curl', 'patch', 'unzip', 'sed', 'tar', 'gzip', 'bzip2', 'man']:
    ensure => present,
  }
}

