#!/usr/bin/env bash

# ensure VirtualBox 4.x is installed
which VirtualBox > /dev/null || (echo 'Install VirtualBox and Extention Pack from http://www.virtualbox.org/wiki/Downloads' && exit 1)
VirtualBox --help | grep 'VirtualBox Manager 4' > /dev/null || (echo 'You must upgrade to VirtualBox 4.x. Download from http://www.virtualbox.org/wiki/Downloads' && exit 2)

# ensure RVM is installed
if [ ! -d "$HOME/.rvm" ]; then
  bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
fi

# load RVM and project config
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
rvm rvmrc trust . > /dev/null
source .rvmrc > /dev/null

# install gems using bundler
which bundle | grep rvm > /dev/null || gem install bundler --version 1.1.3 --no-rdoc --no-ri
bundle check > /dev/null || bundle install

# run build task
rake $@

