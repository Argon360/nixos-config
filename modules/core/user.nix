{ pkgs, ... }:

{
  # Default interactive shell system-wide
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Primary user configuration
  users.users.argon = {
    isNormalUser = true;
    description = "argon";
    extraGroups = [
      "wheel"         # sudo access
      "networkmanager"# network configuration
      "video"         # GPU/display access
      "audio"         # sound devices
      "libvirtd"      # QEMU / KVM virtualization
      "kvm"           # hardware acceleration for VMs
      "input"         # controller / input devices
    ];
    shell = pkgs.zsh;
  };
}
