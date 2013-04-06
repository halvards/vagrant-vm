stage { 'first': before => Stage['main'], } # 'main' is the default single stage
class { 'ubuntu::fixes': stage => 'first', } # Ensure basic fixes are installed first

include apps::chrome
include apps::evince
include fonts::microsoft
include timezone::sydney
include xwindows::hideerrors

