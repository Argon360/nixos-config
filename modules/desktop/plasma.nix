{ pkgs, ... }:

{
  # Display Manager: SDDM with Wayland enabled
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Desktop Environment: KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Enable dconf for GTK application integration in KDE
  programs.dconf.enable = true;

  # KDE Connect integration
  programs.kdeconnect.enable = true;

  # Font configuration matching your current setup
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
