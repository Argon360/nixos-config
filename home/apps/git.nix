{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    # Configure your username and email here:
    # userName = "argon";
    # userEmail = "your.email@example.com";
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      credential.helper = "!gh auth git-credential";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.lazygit = {
    enable = true;
  };
}
