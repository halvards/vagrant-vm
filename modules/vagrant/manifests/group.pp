define vagrant::group($group) {
  exec { "vagrant-group-$group":
    command => "/usr/sbin/usermod --append --groups $group vagrant",
    unless => "/usr/bin/groups vagrant | /bin/grep '$group'",
    require => Group[$group],
  }
}
