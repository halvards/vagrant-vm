class ubuntu::fixes {
  include ubuntu::disable-unattended-upgrades
  include ubuntu::fixgroup
  include ubuntu::updateapt
}

