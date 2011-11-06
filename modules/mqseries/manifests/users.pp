class mqseries::users {
  group { 'mqm':
    name => 'mqm',
    allowdupe => false,
    ensure => present,
  }

  vagrant::group { 'vagrant-mqm':
    group => 'mqm',
  }
}

