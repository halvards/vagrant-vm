stage { 'first': before => Stage['main'], } # 'main' is the default single stage
class { 'ubuntu::fixes': stage => 'first', } # Ensure basic fixes are installed first

include apache::ab
include apps::chrome
include apps::phantomjs
include fonts::microsoft
include editor::idea-ultimate
include editor::ideaplugin-nodejs
include editor::ideaplugin-python
include editor::ideaplugin-ruby
#include editor::janus
include editor::sublime
include editor::vimx
include editor::webstorm
include groovy::gradle
include iptables::disable
include java::oraclejdk7
include nodejs::base
#include python::locust
include python::virtualenv
include ruby::bundler
include squid::base
include timezone::sydney
include vcs::git
include xwindows::hideerrors

