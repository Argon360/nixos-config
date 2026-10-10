{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    cmatrix
    cbonsai
    pipes
  ];
}
