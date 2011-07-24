# workaround for bug in lucid64.box
class fix::lucid {
  group { 'puppet':
    ensure => present,
  }
}

