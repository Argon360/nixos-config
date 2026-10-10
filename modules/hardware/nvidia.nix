{ config, pkgs, ... }:

{
  # Hardware graphics & VA-API video acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Hardware VA-API decoding for Intel Alder Lake
      vpl-gpu-rt           # Intel Quick Sync Video runtime
      libva-vdpau-driver
    ];
  };

  # Load NVIDIA proprietary driver for X11 & Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland compositors (KDE Plasma 6)
    modesetting.enable = true;

    # Power management for laptops (saves battery when RTX 2050 is not in use)
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # GA107 (RTX 2050) runs best with proprietary binary module
    open = false;

    # Enable the nvidia settings control panel app
    nvidiaSettings = true;

    # Stable driver branch (supports explicit sync on Wayland)
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME Hybrid Offload configuration
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Enables `nvidia-offload <program>`
      };

      # Exact PCI Bus IDs from your system:
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Set Wayland environment variables for NVIDIA
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use Intel for video decode by default to save battery
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
}
