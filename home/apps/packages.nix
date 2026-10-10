{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Modern CLI power tools
    dust
    duf
    eza
    tree
    jq
    delta
    micro

    # Development environments
    neovim
    python3
    nodejs
    gnumake
    gcc

    # Internet & Communication
    firefox
    vivaldi
    discord

    # Media & Creation
    mpv
    haruna
    obs-studio

    # Remote access & phone tools
    scrcpy
    remmina

    # Office & productivity
    libreoffice

    # KDE Productivity Tools
    kdePackages.kcalc
    kdePackages.filelight
    kdePackages.kate
    kdePackages.gwenview
    kdePackages.spectacle
  ];
}
