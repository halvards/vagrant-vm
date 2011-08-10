define line::commentout($line, $file) {
  exec { "sed-$name":
    command => "/bin/sed --regexp-extended --in-place 's/($line.*)/# \1/' $file",
    unless => "/bin/grep --extended-regexp '^# $line' $file",
  }
}
