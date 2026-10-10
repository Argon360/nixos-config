{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core system tools
    git
    curl
    wget
    pciutils
    usbutils
    lshw
    nvme-cli
    smartmontools
    lm_sensors
    btop
    htop

    # Archive formats
    zip
    unzip
    p7zip
    unrar

    # Filesystem tools
    btrfs-progs
    dosfstools
    e2fsprogs

    # Wayland / Clipboard utilities
    wl-clipboard
    xclip

    # Text editor fallback
    vim
    nano
  ];
}
