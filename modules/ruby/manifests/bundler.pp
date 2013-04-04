class ruby::bundler {
  include ruby::base

  package { 'bundler':
    provider => gem,
    ensure   => present,
    require  => Class['ruby::base'],
  }
}

