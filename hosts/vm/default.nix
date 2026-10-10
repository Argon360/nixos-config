{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Core, Desktop, and Apps (Shared with Laptop)
    ../../modules/core
    ../../modules/hardware/audio.nix
    ../../modules/hardware/network.nix
    ../../modules/desktop
    ../../modules/services/flatpak.nix
    ../../modules/programs
  ];

  networking.hostName = "nixos-vm";
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # Bootloader override: The VM runs in Legacy BIOS (MBR) mode, so use GRUB on /dev/vda
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  # VM Integration: QEMU guest agent & Spice clipboard/display auto-resize
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  system.stateVersion = "24.11";
}
