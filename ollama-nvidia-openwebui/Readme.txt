Start from minimal install ISO (25.11)
System
machine: q35
Bios: OVMF (UEFI)
Pre-enroll keys: 0
Disks
Bus/ Device: VirtIO Block
Discard
CPU
Type: host
Cores: 16
Memory
memory: 12288
balloon: 0

Na Start
sudo -i
loadkeys be-latin1
git clone https://github.com/stmarco/nixos-install
cd nixos-install
chmod a+x *.sh
./install-UEFI.sh

nixos-generate-config --root /mnt

cp configurationPostGenerate.nix /mnt/etc/nixos/configuration.nix