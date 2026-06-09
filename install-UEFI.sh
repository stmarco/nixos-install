#!/bin/sh
# Create gpt table
parted /dev/sda -- mklabel gpt
# Add boot partition
parted /dev/sda -- mkpart ESP fat32 1MB 1G
# Add swap partition
parted /dev/sda -- mkpart swap linux-swap 1G 9G
# Add root partition
parted /dev/sda -- mkpart root ext4 9G 100%
parted /dev/sda -- set 3 esp on

# Formatting
# Assign a unique symbolic label to the file system
mkfs.fat -F 32 -n boot /dev/sda1
mkswap -L swap /dev/sda2
mkfs.ext4 -L nixos /dev/sda3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
# turn swap on
swapon /dev/sda2
# Generate configuration file
nixos-generate-config --root /mnt
