#!/bin/sh
# Create gpt table
parted /dev/vda -- mklabel gpt
# Add boot partition
parted /dev/vda -- mkpart ESP fat32 1MB 1G
# Add swap partition
parted /dev/vda -- mkpart swap linux-swap 1G 9G
# Add root partition
parted /dev/vda -- mkpart root ext4 9G 100%
parted /dev/vda -- set 3 esp on

# Formatting
# Assign a unique symbolic label to the file system
mkfs.fat -F 32 -n boot /dev/vda1
mkswap -L swap /dev/vda2
mkfs.ext4 -L nixos /dev/vda3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
# turn swap on
swapon /dev/vda2
# Generate configuration file
nixos-generate-config --root /mnt
