{ pkgs, ... }:

{
  # Bootloader setup using modern systemd-boot
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10; # Keep last 10 generations in boot menu
    };
    efi.canTouchEfiVariables = true;
  };

  # High-performance Zen Kernel (tuned for low latency and desktop responsiveness)
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # ZRAM swap (matching CachyOS default behavior for memory compression)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Intel CPU microcode
  hardware.cpu.intel.updateMicrocode = true;
}
