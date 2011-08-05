class grub::disabletimeout {
  exec { '/bin/sed -i "s/timeout=5/timeout=0/" /boot/grub/menu.lst':
  }
}

