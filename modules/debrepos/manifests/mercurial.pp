class debrepos::mercurial {
  $mercurial_ppa_apt_key = '323293EE'

  debrepos::pparepo { 'mercurial-ppa/releases':
    apt_key => $mercurial_ppa_apt_key,
    dist    => $lsbdistcodename,
    require => Debrepos::Pparepo['mercurial-ppa/builddeps'],
  }

  debrepos::pparepo { 'mercurial-ppa/builddeps':
    apt_key => $mercurial_ppa_apt_key,
    dist    => $lsbdistcodename,
  }
}

