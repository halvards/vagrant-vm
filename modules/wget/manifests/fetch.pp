define wget::fetch($source,$destination) {
  if $http_proxy {
    exec { "wget-$name":
      command     => "/usr/bin/wget --output-document=$destination $source",
      creates     => $destination,
      timeout     => 3600, # seconds
      require     => Package['wget'],
      environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
    }
  } else {
    exec { "wget-$name":
      command => "/usr/bin/wget --output-document=$destination $source",
      creates => $destination,
      timeout => 3600, # seconds
      require => Package['wget'],
    }
  }
}

