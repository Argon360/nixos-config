{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Note: If you have ~/.config/starship.toml, Starship will automatically read it.
    # To manage settings declaratively in Nix, configure `settings` attribute here.
  };
}
