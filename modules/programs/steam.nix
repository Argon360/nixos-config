{ pkgs, ... }:

{
  # Steam configuration with 32-bit graphics and firewall ports
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Feral Interactive GameMode daemon for CPU/GPU governor optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1; # Target NVIDIA GPU
        nv_powermizer_mode = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
  ];
}
