{ ... }:

{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    # Allow KDE Connect and local discovery
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };
}
