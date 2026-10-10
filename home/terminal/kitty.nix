{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12.0;
    };
    settings = {
      background_opacity = "0.85";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
    };
  };
}
