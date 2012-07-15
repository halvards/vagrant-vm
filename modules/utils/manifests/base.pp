class utils::base {
  if ! defined(Package['bash'])      { package { 'bash':      ensure => present } }
  if ! defined(Package['bzip2'])     { package { 'bzip2':     ensure => present } }
  if ! defined(Package['coreutils']) { package { 'coreutils': ensure => present } }
  if ! defined(Package['curl'])      { package { 'curl':      ensure => present } }
  if ! defined(Package['gzip'])      { package { 'gzip':      ensure => present } }
  if ! defined(Package['patch'])     { package { 'patch':     ensure => present } }
  if ! defined(Package['sed'])       { package { 'sed':       ensure => present } }
  if ! defined(Package['tar'])       { package { 'tar':       ensure => present } }
  if ! defined(Package['unzip'])     { package { 'unzip':     ensure => present } }
  if ! defined(Package['wget'])      { package { 'wget':      ensure => present } }
  if ! defined(Package['zip'])       { package { 'zip':       ensure => present } }

  case $operatingsystem {
    'CentOS': {
      if ! defined(Package['man'])   { package { 'man':   ensure => present } }
    }
    'Ubuntu': {
      if ! defined(Package['man'])   { package { 'man':   ensure => present, name => 'man-db', } }
      if ! defined(Package['unrar']) { package { 'unrar': ensure => present } }
    }
  }
}

