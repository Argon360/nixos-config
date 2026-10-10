# Note: When installing NixOS, replace this file with the output of:
#   nixos-generate-config --show-hardware-config
# Or let nixos-install generate it automatically into /etc/nixos/hardware-configuration.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Target configuration for installing onto the 60GB partition (nvme0n1p5)
  # or replace with your UUIDs if formatting fresh.
  fileSystems."/" = {
    device = "/dev/disk/by-label/Experimental"; # /dev/nvme0n1p5
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/Cachy-Boot"; # /dev/nvme0n1p1 (existing EFI)
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Optional: mount your current home or lab partitions if desired
  # fileSystems."/mnt/lab" = {
  #   device = "/dev/disk/by-label/LAB+Shared";
  #   fsType = "btrfs";
  # };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
