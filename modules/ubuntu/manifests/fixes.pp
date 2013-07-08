class ubuntu::fixes {
  include ubuntu::disable-unattended-upgrades
  include ubuntu::disableipv6
  include ubuntu::fixgroup
  include ubuntu::updateapt
}

