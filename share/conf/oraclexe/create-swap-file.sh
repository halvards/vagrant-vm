#!/usr/bin/env bash

# Exit on any error (non-zero return code)
set -e

# Create swapfile of 2GB with block size 1MB
/bin/dd if=/dev/zero of=/swapfile bs=1024 count=2097152

# Create swapfile of 1GB with block size 1MB
#/bin/dd if=/dev/zero of=/swapfile bs=1024 count=1048576

# Set up the swap file
/sbin/mkswap /swapfile

# Enable swap file immediately
/sbin/swapon /swapfile

# Enable swap file on every boot
/bin/echo '/swapfile          swap            swap    defaults        0 0' >> /etc/fstab

