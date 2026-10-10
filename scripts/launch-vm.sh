#!/usr/bin/env bash
set -euo pipefail

ISO_DIR="/mnt/lab/ISOs"
VM_DIR="/mnt/lab/VMs"
ISO_NAME="nixos-plasma6-24.11.iso"
ISO_PATH="$ISO_DIR/$ISO_NAME"
ISO_URL="https://channels.nixos.org/nixos-24.11/latest-nixos-plasma6-x86_64-linux.iso"
DISK_PATH="$VM_DIR/nixos-test.qcow2"
VM_NAME="nixos-test"

echo "=========================================================="
echo "          NixOS VM Setup & Launcher for argon             "
echo "=========================================================="

mkdir -p "$ISO_DIR" "$VM_DIR"

# 1. Download ISO if not already cached
if [ ! -f "$ISO_PATH" ]; then
    echo "[*] NixOS 24.11 Plasma 6 ISO not found in $ISO_DIR."
    echo "[*] Downloading official ISO (~2.6 GB)..."
    curl -L --progress-bar "$ISO_URL" -o "$ISO_PATH"
else
    echo "[✓] Found cached NixOS ISO at: $ISO_PATH"
fi

# 2. Check if VM is already created
if virsh -c qemu:///system dominfo "$VM_NAME" &>/dev/null; then
    echo "[*] VM '$VM_NAME' already exists."
    STATE=$(virsh -c qemu:///system domstate "$VM_NAME" 2>/dev/null || echo "shut off")
    if [ "$STATE" != "running" ]; then
        echo "[*] Starting '$VM_NAME'..."
        virsh -c qemu:///system start "$VM_NAME"
    fi
    echo "[*] Opening Virt-Manager console..."
    virt-manager --connect qemu:///system --show-domain-console "$VM_NAME" &
    exit 0
fi

# 3. Create fresh VM disk
if [ -f "$DISK_PATH" ]; then
    echo "[*] Removing previous test disk: $DISK_PATH"
    rm -f "$DISK_PATH"
fi

echo "[*] Provisioning new VM '$VM_NAME' (4 vCPUs, 6GB RAM, 30GB Disk, UEFI)..."
virt-install \
  --connect qemu:///system \
  --name "$VM_NAME" \
  --memory 6144 \
  --vcpus 4 \
  --disk path="$DISK_PATH",size=30,bus=virtio,format=qcow2 \
  --cdrom "$ISO_PATH" \
  --os-variant nixos-24.11 \
  --network network=default,model=virtio \
  --graphics spice,listen=127.0.0.1 \
  --video virtio \
  --channel spicevmc \
  --boot uefi \
  --noautoconsole

echo "[✓] VM '$VM_NAME' created and started!"
echo "[*] Opening Virt-Manager console..."
virt-manager --connect qemu:///system --show-domain-console "$VM_NAME" &

echo ""
echo "=========================================================="
echo "                  INSIDE THE VM CONSOLE                   "
echo "=========================================================="
echo "Once the NixOS live desktop loads, open Konsole and run:"
echo ""
echo "  curl -sSL https://raw.githubusercontent.com/Argon360/nixos-config/main/scripts/vm-install.sh | sudo bash"
echo ""
echo "This will partition, clone your GitHub repo, apply your config,"
echo "and install NixOS with your exact KDE + tools setup automatically!"
echo "=========================================================="
