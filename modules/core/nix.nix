{ pkgs, ... }:

{
  # Allow non-free packages (Discord, Steam, NVIDIA proprietary drivers, etc.)
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable Flakes and new CLI tools
    experimental-features = [ "nix-command" "flakes" ];

    # Deduplicate store links to save disk space
    auto-optimise-store = true;

    # Trusted users for binary caches and commands
    trusted-users = [ "root" "argon" ];
  };

  # Automatic garbage collection to prevent the Nix store from filling up the disk
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # nix-ld: Runs standard pre-compiled dynamically linked Linux binaries
  # without needing patchelf. Essential for Neovim Mason LSPs, VS Code servers, etc.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      glib
      libstdcxx5
    ];
  };
}
