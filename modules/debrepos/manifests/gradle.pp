class debrepos::gradle {
  $gradle_ppa_apt_key = '9D06AF36'

  debrepos::pparepo { 'cwchien/gradle':
    apt_key => $gradle_ppa_apt_key,
    dist    => $lsbdistcodename,
  }
}

