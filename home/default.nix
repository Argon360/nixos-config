{ pkgs, ... }:

{
  home.username = "argon";
  home.homeDirectory = "/home/argon";

  # Home Manager release version
  home.stateVersion = "24.11";

  # Allow Home Manager to install and manage its own packages
  programs.home-manager.enable = true;

  imports = [
    ./shell
    ./terminal
    ./apps
  ];
}
