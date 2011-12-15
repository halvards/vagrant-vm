define line::present($file, $line) {
  exec { "/bin/echo '${line}' >> '${file}'":
    unless => "/bin/grep -qFx '${line}' '${file}'",
  }
}

