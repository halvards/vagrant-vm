class repos::all {
  case $operatingsystem {
    'Centos': {
      include yumrepos::epel
      include yumrepos::google
      include yumrepos::jpackage
      include yumrepos::rbel
      include yumrepos::rpmforge
      include yumrepos::rubyee
    }
    'Ubuntu': {
      include debrepos::partner
    }
  }
}

