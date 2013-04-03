# http://docs.puppetlabs.com/puppet/latest/reference/lang_run_stages.html
stage { 'first':
  before => Stage['main'], # 'main' is the default single stage
}
#stage { 'last': }
#Stage['main'] -> Stage['last']

class { 'ubuntu::fixes': stage => 'first', }

include apps::chrome
include debrepos::partner
include fonts::microsoft
include editor::idea-ultimate
#include editor::janus
include editor::vimx
include java::oraclejdk7
include timezone::sydney
include ubuntu::keybindings
include utils::base
include xwindows::hideerrors

