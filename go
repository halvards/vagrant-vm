#!/usr/bin/env bash

# ensure VirtualBox 4.x is installed
which VirtualBox > /dev/null || (echo 'Install VirtualBox and Extention Pack from http://www.virtualbox.org/wiki/Downloads' && exit 1)
VirtualBox --help | grep 'VirtualBox Manager 4' > /dev/null || (echo 'You must upgrade to VirtualBox 4.x. Download from http://www.virtualbox.org/wiki/Downloads' && exit 2)

# install gems using bundler
which bundle | grep rvm > /dev/null || gem install bundler --no-rdoc --no-ri
bundle check > /dev/null || bundle install

# run build task
rake $@

