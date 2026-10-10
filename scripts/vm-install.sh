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

echo "[*] Cleaning up any existing mounts or background installers..."
killall calamares 2>/dev/null || true
umount -R /mnt 2>/dev/null || true
swapoff -a 2>/dev/null || true
for part in "${DISK}"*; do
    [ -b "$part" ] && umount -f "$part" 2>/dev/null || true
done
sleep 1

echo "[1/4] Partitioning $DISK (GPT: 512MB EFI + rest for root)..."
# Wipe signatures to prevent conflict
wipefs -a "$DISK" 2>/dev/null || true

parted --script "$DISK" \
    mklabel gpt \
    mkpart ESP fat32 1MiB 512MiB \
    set 1 esp on \
    mkpart primary ext4 512MiB 100%

# Notify kernel and settle device nodes
partprobe "$DISK" 2>/dev/null || true
udevadm trigger 2>/dev/null || true
udevadm settle

echo "[2/4] Formatting partitions..."
mkfs.fat -F 32 -n boot "${DISK}1"
mkfs.ext4 -F -L nixos "${DISK}2"

udevadm trigger 2>/dev/null || true
udevadm settle
sleep 1

echo "[3/4] Mounting partitions to /mnt..."
mount "${DISK}2" /mnt
mkdir -p /mnt/boot
mount "${DISK}1" /mnt/boot

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
