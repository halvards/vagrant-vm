# workaround for bug in lucid64.box
class ubuntu::fixgroup {
  group { 'puppet':
    ensure => present,
  }
}

