{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.8;
        dynamic_padding = true;
        decorations = "Full";
        title = "Alacritty@NixOS";
        dimensions = {
          columns = 100;
          lines = 30;
        };
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };
      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "0x2E3440";
          foreground = "0xD8DEE9";
        };
      };
    };
  };
}
