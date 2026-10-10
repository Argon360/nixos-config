{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      home = "cd ~";

      # Editors
      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      # System monitors & info
      top = "btop --force-utf";
      mem = "free -h";
      cpu = "lscpu | less";
      ipinfo = "ip -c a";
      ports = "ss -tulnp";
      myip = "curl -s ifconfig.me";

      # Clipboard
      clip = "wl-copy";
      paste = "wl-paste";

      # Utilities
      cls = "clear";
      c = "clear";
      now = "date +\"%Y-%m-%d %H:%M:%S\"";
      reload = "source ~/.zshrc";
      restart = "exec zsh";

      # Git & GitHub
      gs = "git status";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit";
      gcm = "git commit -m";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git log --oneline --decorate";
      gp = "git push";
      gpl = "git pull";
      gsw = "git switch";

      # Fastfetch
      ff = "fastfetch";

      # GPU Offload
      run-gpu = "nvidia-offload";

      # NixOS Lifecycle Commands (replacing pacman/paru)
      sysup = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      sysboot = "sudo nixos-rebuild boot --flake ~/nixos-config#laptop";
      sysupdate = "nix flake update --flake ~/nixos-config && sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      nixclean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nixsearch = "nix search nixpkgs";
    };

    initExtra = ''
      # Export default editor
      export EDITOR=nvim
      export VISUAL=nvim
      export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"

      # Preserve any existing modular zsh scripts if present
      if [ -d "$HOME/.config/zsh" ]; then
        for f in "$HOME/.config/zsh"/*.zsh; do
          [ -f "$f" ] && source "$f"
        done
      fi
    '';
  };

  # Shell productivity tools
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
