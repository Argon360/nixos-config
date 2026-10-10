#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "   NixOS Automated VM Installation Script (argon)        "
echo "=========================================================="

DISK="/dev/vda"

if [ ! -b "$DISK" ]; then
    echo "Error: Target disk $DISK not found! Available disks:"
    lsblk
    exit 1
fi

echo "[1/5] Partitioning $DISK (GPT: 512MB EFI + rest for root)..."
parted --script "$DISK" \
    mklabel gpt \
    mkpart ESP fat32 1MiB 512MiB \
    set 1 esp on \
    mkpart primary ext4 512MiB 100%

# Wait for kernel to reread partition table
udevadm settle

echo "[2/5] Formatting partitions..."
mkfs.fat -F 32 -n boot "${DISK}1"
mkfs.ext4 -F -L nixos "${DISK}2"

echo "[3/5] Mounting partitions to /mnt..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "[4/5] Copying nixos-config and generating hardware config..."
mkdir -p /mnt/etc/nixos
cp -r /etc/nixos/* /mnt/etc/nixos/

# Generate VM hardware config
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/vm/

echo "[5/5] Running nixos-install (Flake profile: #vm)..."
cd /mnt/etc/nixos
git config --global user.name "argon" 2>/dev/null || true
git config --global user.email "argon@localhost" 2>/dev/null || true
git add . 2>/dev/null || true
nixos-install --flake .#vm --no-root-passwd

echo "=========================================================="
echo " Installation Complete!"
echo " You can now run: reboot"
echo "=========================================================="
