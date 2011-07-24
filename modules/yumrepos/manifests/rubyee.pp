class yumrepos::rubyee {
  package { 'ruby-enterprise-opt-repo':
    provider => rpm,
    ensure => present,
    source => '/vagrant-share/repos/ruby-enterprise-opt-repo-1.0-1.x86_64.rpm',
  }
}

