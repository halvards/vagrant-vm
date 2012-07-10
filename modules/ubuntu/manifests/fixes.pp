class ubuntu::fixes {
  include ubuntu::disable-unattended-upgrades
  include ubuntu::fixgroup
}

