class debrepos::nodejs {
  $nodejs_ppa_apt_key = 'C7917B12'

  debrepos::pparepo { 'chris-lea/node.js':
    apt_key => $nodejs_ppa_apt_key,
    dist    => $lsbdistcodename,
  }
}

