#
# Reboot or run '/sbin/sysctl -p' to take effect
#
class ubuntu::disableipv6 {
  $sysctl_conf_file = '/etc/sysctl.conf'

  line::present { 'disable-ipv6-all':
    file => $sysctl_conf_file,
    line => 'net.ipv6.conf.all.disable_ipv6 = 1',
  }

  line::present { 'disable-ipv6-default':
    file => $sysctl_conf_file,
    line => 'net.ipv6.conf.default.disable_ipv6 = 1',
  }

  line::present { 'disable-ipv6-lo':
    file => $sysctl_conf_file,
    line => 'net.ipv6.conf.lo.disable_ipv6 = 1',
  }
}

