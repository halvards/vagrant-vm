define wget::fetch($source,$destination) {
  if $http_proxy {
    exec { "wget-$name":
      command     => "/usr/bin/wget --no-verbose --output-document=$destination $source",
      creates     => $destination,
      timeout     => 3600, # seconds
      logoutput   => true,
      require     => Package['wget'],
      environment => [ "HTTP_PROXY=$http_proxy", "http_proxy=$http_proxy" ],
    }
  } else {
    exec { "wget-$name":
      command   => "/usr/bin/wget --no-verbose --output-document=$destination $source",
      creates   => $destination,
      timeout   => 3600, # seconds
      logoutput => true,
      require   => Package['wget'],
    }
  }
}

