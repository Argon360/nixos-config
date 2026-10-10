{ config, pkgs, ... }:

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

  # VM Integration: QEMU guest agent & Spice clipboard/display auto-resize
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  system.stateVersion = "24.11";
}
