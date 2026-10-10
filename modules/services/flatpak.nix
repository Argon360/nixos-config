{ ... }:

{
  # Flatpak runtime support (useful for apps not yet in nixpkgs, or sandboxed apps)
  services.flatpak.enable = true;

  # XDG desktop integration
  xdg.portal = {
    enable = true;
  };
}
