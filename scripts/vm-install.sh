#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "   NixOS Automated VM Installation via Git (argon)       "
echo "=========================================================="

REPO_URL="https://github.com/Argon360/nixos-config.git"
DISK="/dev/vda"

if [ ! -b "$DISK" ]; then
    echo "Error: Target disk $DISK not found! Available disks:"
    lsblk
    exit 1
fi

echo "[1/4] Partitioning $DISK (GPT: 512MB EFI + rest for root)..."
parted --script "$DISK" \
    mklabel gpt \
    mkpart ESP fat32 1MiB 512MiB \
    set 1 esp on \
    mkpart primary ext4 512MiB 100%

udevadm settle

echo "[2/4] Formatting partitions..."
mkfs.fat -F 32 -n boot "${DISK}1"
mkfs.ext4 -F -L nixos "${DISK}2"

echo "[3/4] Mounting partitions to /mnt..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "[4/4] Cloning configuration from GitHub: $REPO_URL..."
mkdir -p /mnt/etc/nixos
git clone "$REPO_URL" /mnt/etc/nixos

echo "[*] Generating hardware config for the VM..."
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/vm/

echo "[*] Running nixos-install (Flake target: #vm)..."
cd /mnt/etc/nixos
git config --global user.name "argon" 2>/dev/null || true
git config --global user.email "argon@localhost" 2>/dev/null || true
git add -A 2>/dev/null || true
nixos-install --flake .#vm --no-root-passwd

echo "=========================================================="
echo " Installation Complete!"
echo " You can now run: reboot"
echo "=========================================================="
