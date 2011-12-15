class rvm::dependencies {
  case $operatingsystem {
    'CentOS': {
      if ! defined(Package['which'])            { package { 'which':            ensure => present } }
      if ! defined(Package['gcc'])              { package { 'gcc':              ensure => present } }
      if ! defined(Package['gcc-c++'])          { package { 'gcc-c++':          ensure => present } }
      if ! defined(Package['make'])             { package { 'make':             ensure => present } }
      if ! defined(Package['gettext-devel'])    { package { 'gettext-devel':    ensure => present } }
      if ! defined(Package['expat-devel'])      { package { 'expat-devel':      ensure => present } }
      if ! defined(Package['zlib-devel'])       { package { 'zlib-devel':       ensure => present } }
      if ! defined(Package['openssl-devel'])    { package { 'openssl-devel':    ensure => present } }
      if ! defined(Package['perl'])             { package { 'perl':             ensure => present } }
      if ! defined(Package['cpio'])             { package { 'cpio':             ensure => present } }
      if ! defined(Package['expat-devel'])      { package { 'expat-devel':      ensure => present } }
      if ! defined(Package['gettext-devel'])    { package { 'gettext-devel':    ensure => present } }
      if ! defined(Package['wget'])             { package { 'wget':             ensure => present } }
      if ! defined(Package['bzip2'])            { package { 'bzip2':            ensure => present } }
      if ! defined(Package['sendmail'])         { package { 'sendmail':         ensure => present } }
      if ! defined(Package['mailx'])            { package { 'mailx':            ensure => present } }
      if ! defined(Package['libxml2'])          { package { 'libxml2':          ensure => present } }
      if ! defined(Package['libxml2-devel'])    { package { 'libxml2-devel':    ensure => present } }
      if ! defined(Package['libxslt'])          { package { 'libxslt':          ensure => present } }
      if ! defined(Package['libxslt-devel'])    { package { 'libxslt-devel':    ensure => present } }
      if ! defined(Package['readline-devel'])   { package { 'readline-devel':   ensure => present } }
      if ! defined(Package['patch'])            { package { 'patch':            ensure => present } }
      if ! defined(Package['git'])              { package { 'git':              ensure => present } }
      if ! defined(Package['curl'])             { package { 'curl':             ensure => present } }
    }
    'Ubuntu': {
      if ! defined(Package['build-essential'])  { package { 'build-essential':  ensure => present } }
      if ! defined(Package['bison'])            { package { 'bison':            ensure => present } }
      if ! defined(Package['openssl'])          { package { 'openssl':          ensure => present } }
      if ! defined(Package['libreadline6'])     { package { 'libreadline6':     ensure => present } }
      if ! defined(Package['libreadline6-dev']) { package { 'libreadline6-dev': ensure => present } }
      if ! defined(Package['curl'])             { package { 'curl':             ensure => present } }
      if ! defined(Package['git'])              { package { 'git':              ensure => present, name => 'git-core' } }
      if ! defined(Package['zlib1g'])           { package { 'zlib1g':           ensure => present } }
      if ! defined(Package['zlib1g-dev'])       { package { 'zlib1g-dev':       ensure => present } }
      if ! defined(Package['libssl-dev'])       { package { 'libssl-dev':       ensure => present } }
      if ! defined(Package['libyaml-dev'])      { package { 'libyaml-dev':      ensure => present } }
      if ! defined(Package['libsqlite3-0'])     { package { 'libsqlite3-0':     ensure => present } }
      if ! defined(Package['libsqlite3-dev'])   { package { 'libsqlite3-dev':   ensure => present } }
      if ! defined(Package['sqlite3'])          { package { 'sqlite3':          ensure => present } }
      if ! defined(Package['libxml2-dev'])      { package { 'libxml2-dev':      ensure => present } }
      if ! defined(Package['libxslt-dev'])      { package { 'libxslt-dev':      ensure => present, name => 'libxslt1-dev' } }
      if ! defined(Package['autoconf'])         { package { 'autoconf':         ensure => present } }
      if ! defined(Package['libc6-dev'])        { package { 'libc6-dev':        ensure => present } }
    }
  }
}

