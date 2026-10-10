#!/usr/bin/env python3
import subprocess
import time
import sys
import os

ISO_PATH = "/mnt/lab/ISOs/nixos-graphical-26.05.11576.7c8764b7c7b0-x86_64-linux.iso"
DISK_PATH = "/mnt/lab/VMs/nixos-test.qcow2"
BOOT_DIR = "/tmp/nixos-iso-boot"
LOG_PATH = "/home/argon/nixos-config/install.log"

print("==========================================================")
print("     NixOS 100% Automated Headless Installer (argon)      ")
print("==========================================================")

# 1. Reset disk image
print("[1/5] Creating fresh 30GB QCOW2 virtual disk...")
if os.path.exists(DISK_PATH):
    os.remove(DISK_PATH)
subprocess.run(["qemu-img", "create", "-f", "qcow2", DISK_PATH, "30G"], check=True)

# 2. Extract boot files if needed
os.makedirs(BOOT_DIR, exist_ok=True)
if not os.path.exists(f"{BOOT_DIR}/bzImage") or not os.path.exists(f"{BOOT_DIR}/initrd"):
    print("[2/5] Extracting kernel and initrd from ISO...")
    subprocess.run([
        "7z", "e", "-y", f"-o{BOOT_DIR}", ISO_PATH,
        "boot/nix/store/7y85q826qh9jmxd06dmlbyl5cqb2l3ky-linux-7.2.9/bzImage",
        "boot/nix/store/xb3a5r4113v6rh1a96l5g7i1dzz7fxhz-initrd-linux-7.2.9/initrd"
    ], check=True)

# 3. Launch headless QEMU
print("[3/5] Starting headless VM with 4 vCPUs and 6GB RAM...")
cmd = [
    "qemu-system-x86_64",
    "-enable-kvm",
    "-m", "6144",
    "-smp", "4",
    "-kernel", f"{BOOT_DIR}/bzImage",
    "-initrd", f"{BOOT_DIR}/initrd",
    "-append", (
        "init=/nix/store/kshnb9dz6gsr5fivs1lfm2jdrahnsgxi-nixos-system-nixos-26.05.11576.7c8764b7c7b0/init "
        "elevator=noop root=fstab splash=0 loglevel=4 console=ttyS0 systemd.mask=display-manager.service"
    ),
    "-drive", f"file={ISO_PATH},media=cdrom,readonly=on",
    "-drive", f"file={DISK_PATH},if=virtio,format=qcow2",
    "-netdev", "user,id=net0",
    "-device", "virtio-net-pci,netdev=net0",
    "-nographic",
    "-serial", "mon:stdio"
]

proc = subprocess.Popen(
    cmd,
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True,
    bufsize=1
)

log_file = open(LOG_PATH, "w")

def log(msg):
    sys.stdout.write(msg)
    sys.stdout.flush()
    log_file.write(msg)
    log_file.flush()

log("[*] Waiting for NixOS live environment to boot...\n")
start_time = time.time()
booted = False

while time.time() - start_time < 90:
    line = proc.stdout.readline()
    if not line:
        break
    log_file.write(line)
    log_file.flush()
    if "@nixos:" in line:
        booted = True
        log("[✓] NixOS interactive shell ready!\n")
        break

if not booted:
    log("[!] Error: Timed out waiting for NixOS live shell.\n")
    proc.terminate()
    sys.exit(1)

# Allow shell to settle
time.sleep(2)

# Build a standalone installer script file on the guest to avoid any pipe/quote issues
commands = [
    "cat << 'EOF' > /tmp/do-install.sh",
    "#!/usr/bin/env bash",
    "set -euxo pipefail",
    "echo '>>> [1/5] Partitioning /dev/vda...'",
    "parted /dev/vda --script mklabel gpt mkpart ESP fat32 1MiB 512MiB set 1 esp on mkpart primary ext4 512MiB 100%",
    "partprobe /dev/vda",
    "sleep 1",
    "echo '>>> [2/5] Formatting filesystems...'",
    "mkfs.fat -F 32 -n boot /dev/vda1",
    "mkfs.ext4 -F -L nixos /dev/vda2",
    "echo '>>> [3/5] Mounting /mnt...'",
    "mount /dev/vda2 /mnt",
    "mkdir -p /mnt/boot",
    "mount /dev/vda1 /mnt/boot",
    "echo '>>> [4/5] Cloning https://github.com/Argon360/nixos-config...'",
    "git clone https://github.com/Argon360/nixos-config.git /mnt/etc/nixos",
    "nixos-generate-config --root /mnt",
    "cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/vm/",
    "cd /mnt/etc/nixos",
    "git config --global user.name 'argon'",
    "git config --global user.email 'argon@localhost'",
    "git add -A",
    "echo '>>> [5/5] Running nixos-install (Flake target: #vm)...'",
    "nixos-install --flake .#vm --no-root-passwd",
    "echo '>>> ALL DONE! Powering off...'",
    "sync",
    "poweroff",
    "EOF",
    "chmod +x /tmp/do-install.sh",
    "sudo /tmp/do-install.sh"
]

log("[4/5] Deploying and starting automated install script inside VM...\n")
for c in commands:
    proc.stdin.write(c + "\n")
    proc.stdin.flush()
    time.sleep(0.3)

# Stream live installer output
while True:
    line = proc.stdout.readline()
    if not line:
        break
    log(line)
    if "ALL DONE!" in line or "Power down" in line or "systemd-shutdown" in line:
        break

proc.wait()
log_file.close()

print("\n[5/5] NixOS installation completed successfully!")

# Register in Libvirt / virt-manager
print("[*] Registering VM 'nixos-test' in virt-manager...")
subprocess.run(["virsh", "-c", "qemu:///system", "undefine", "nixos-test", "--nvram"], capture_output=True)

subprocess.run([
    "virt-install",
    "--connect", "qemu:///system",
    "--name", "nixos-test",
    "--memory", "6144",
    "--vcpus", "4",
    "--disk", f"path={DISK_PATH},bus=virtio",
    "--import",
    "--os-variant", "nixos-unstable",
    "--network", "network=default,model=virtio",
    "--graphics", "spice,listen=127.0.0.1",
    "--video", "virtio",
    "--channel", "spicevmc",
    "--boot", "uefi",
    "--noautoconsole"
], check=True)

print("[✓] VM is registered and ready!")
print("[*] Launching Virt-Manager...")
subprocess.Popen(["virt-manager", "--connect", "qemu:///system", "--show-domain-console", "nixos-test"])

print("==========================================================")
print(" Installation Complete! Your NixOS VM is now running!     ")
print("==========================================================")
