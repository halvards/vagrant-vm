stage { 'first': before => Stage['main'], } # 'main' is the default single stage
class { 'ubuntu::fixes': stage => 'first', } # Ensure basic fixes are installed first

include timezone::sydney
include utils::base

