# gThumb can import from Picasa or Flickr and export to Facebook, Flickr, Photobucker, Picasa
class apps::gthumb {
  debrepos::pparepo { 'webupd8team/gthumb':
    apt_key => 'EEA14886',
  }

  package { 'gthumb':
    ensure  => present,
    require => Debrepos::Pparepo['webupd8team/gthumb'],
  }
}

