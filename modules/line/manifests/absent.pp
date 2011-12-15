define line::absent($file, $line) {
  exec { "/bin/grep -vFx '${line}' '${file}' | /usr/bin/tee '${file}' > /dev/null 2>&1":
    onlyif => "/bin/grep -qFx '${line}' '${file}'",
  }
}

