# Fast preview for Nautilus file manager
class apps::gloobus {
  debrepos::pparepo { 'gloobus-dev/gloobus-preview':
    apt_key => 'EB13C954',
  }

  package { 'gloobus-preview':
    ensure  => present,
    require => Debrepos::Pparepo['gloobus-dev/gloobus-preview'],
  }

  # replace default Nautilus previewer
  package { 'gloobus-sushi':
    ensure  => present,
    require => Package['gloobus-preview'],
  }
}

