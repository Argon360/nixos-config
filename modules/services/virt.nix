{ pkgs, ... }:

{
  # Libvirt daemon with QEMU/KVM
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  # GUI frontend
  programs.virt-manager.enable = true;

  # SPICE USB redirection for passing USB devices into VMs
  virtualisation.spiceUSBRedirection.enable = true;
}
