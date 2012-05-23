# Very lightweight picture slideshow application. No Picasa or Flickr integration
class apps::gpicview {
  package { 'gpicview':
    ensure => present,
  }
}

