# Set limit of watched file handles (inotify)
# http://confluence.jetbrains.net/display/IDEADEV/Inotify+Watches+Limit
class utils::inotifylimit {
  line::present { 'inotify-watch-limit':
    file => '/etc/sysctl.conf',
    line => 'fs.inotify.max_user_watches = 524288',
  }

  exec { 'apply-inotify-watch-limit':
    command => '/sbin/sysctl -p',
    unless  => '/sbin/sysctl fs.inotify.max_user_watches | /bin/grep 524288',
    require => Line::Present['inotify-watch-limit'],
  }
}

