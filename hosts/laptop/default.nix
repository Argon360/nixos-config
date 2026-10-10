{ config, pkgs, ... }:

{
  imports = [
    # Machine-specific hardware detection
    ./hardware-configuration.nix

    # System modules
    ../../modules/core
    ../../modules/hardware
    ../../modules/desktop
    ../../modules/services
    ../../modules/programs
  ];

  networking.hostName = "cachy-nix";

  # Set your time zone & locale (from current system: Asia/Kolkata)
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # NixOS state version
  system.stateVersion = "24.11";
}
