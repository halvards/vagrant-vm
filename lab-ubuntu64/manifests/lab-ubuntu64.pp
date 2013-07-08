stage { 'first': before => Stage['main'], } # 'main' is the default single stage
class { 'ubuntu::fixes': stage => 'first', } # Ensure basic fixes are installed first

include apache::ab
include apps::browsermob_proxy
include apps::chrome
include apps::phantomjs
include fonts::microsoft
include editor::janus
include editor::sublime
include editor::vimx
include editor::webstorm
include iptables::disable
include java::oraclejdk7
include nodejs::base
include python::locust
include ruby::bundler
class { 'squid::accelerator':
  proxy_port       => '80',
  application_port => '8000',
}
include timezone::sydney
include vcs::git
include xwindows::hideerrors

