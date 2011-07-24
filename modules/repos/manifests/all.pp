class repos::all {
  case $operatingsystem {
    'Centos': {
      include yumrepos::rpmforge
      include yumrepos::epel
      include yumrepos::elff
      include yumrepos::jpackage
      include yumrepos::rubyee
      include yumrepos::google
    }
    'Ubuntu': {
      include debrepos::partner
    }
  }
}

