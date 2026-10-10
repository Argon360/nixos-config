# argon's Modular NixOS Configuration

A modular NixOS Flake configuration reproducing the CachyOS experience:
- **Repository:** `https://github.com/Argon360/nixos-config`
- **Desktop:** KDE Plasma 6 on Wayland (SDDM)
- **Hardware:** Intel 12th Gen Alder Lake + NVIDIA GeForce RTX 2050 (GA107) with PRIME Offload
- **Kernel:** Linux Zen Kernel + ZRAM swap
- **Shell & Tools:** Zsh + Starship + Atuin + Zoxide + Alacritty / Kitty
- **Features:** Libvirt/QEMU, Flatpak, Steam + GameMode, `nix-ld` for running precompiled binaries

---

## Directory Structure

```
nixos-config/
├── flake.nix                               # Flake entrypoint & outputs (#laptop, #vm)
├── README.md                               # Quick guide & command reference
├── hosts/
│   ├── laptop/
│   │   ├── default.nix                     # Physical laptop configuration (RTX 2050 + Intel)
│   │   └── hardware-configuration.nix      # Hardware mounts & CPU microcode
│   └── vm/
│       ├── default.nix                     # VM testing configuration (VirtIO + SPICE)
│       └── hardware-configuration.nix      # QEMU guest profile
├── modules/                                # System-level NixOS modules
│   ├── core/
│   │   ├── boot.nix                        # Zen kernel, systemd-boot, zram
│   │   ├── nix.nix                         # Flakes, GC, nix-ld
│   │   ├── security.nix                    # Sudo, Polkit, RTKit
│   │   └── user.nix                        # User account argon & groups
│   ├── hardware/
│   │   ├── nvidia.nix                      # RTX 2050 + Intel PRIME offload
│   │   ├── audio.nix                       # PipeWire & WirePlumber
│   │   ├── bluetooth.nix                   # BlueZ
│   │   └── network.nix                     # NetworkManager & firewall
│   ├── desktop/
│   │   └── plasma.nix                      # KDE Plasma 6 + SDDM Wayland + fonts
│   ├── services/
│   │   ├── virt.nix                        # Libvirt, KVM, Virt-Manager
│   │   └── flatpak.nix                     # Flatpak runtime & portals
│   └── programs/
│       ├── steam.nix                       # Steam & GameMode
│       └── packages.nix                    # System-wide CLI utilities
├── home/                                   # Home Manager (User space for 'argon')
│   ├── default.nix                         # User entrypoint
│   ├── shell/
│   │   ├── zsh.nix                         # Custom aliases, plugins, Atuin, Zoxide
│   │   ├── starship.nix                    # Starship prompt
│   │   └── fastfetch.nix                   # Fastfetch & terminal toys
│   ├── terminal/
│   │   ├── alacritty.nix                   # Alacritty (Nord dark, 0.8 opacity)
│   │   └── kitty.nix                       # Kitty
│   └── apps/
│       ├── git.nix                         # Git, GitHub CLI, Lazygit
│       └── packages.nix                    # Desktop GUI apps (Firefox, Discord, etc.)
└── scripts/
    ├── launch-vm.sh                        # Host script to provision & launch test VM
    └── vm-install.sh                       # In-VM script to auto-partition and install via Git
```

---

## Testing in VM via Git

1. Launch VM on host:
   ```bash
   ~/nixos-config/scripts/launch-vm.sh
   ```
2. In the VM console, run:
   ```bash
   curl -sSL https://raw.githubusercontent.com/Argon360/nixos-config/main/scripts/vm-install.sh | sudo bash
   ```

---

## Daily Commands (Configured in Zsh)

| Command | Action |
|---|---|
| `sysup` | Rebuild system and switch to new configuration |
| `sysboot` | Build system and set as default for next boot |
| `sysupdate` | Update flake inputs (packages/kernel) and rebuild |
| `nixclean` | Delete old generations and garbage collect store |
| `nixsearch <pkg>` | Search for packages in Nixpkgs |
| `run-gpu <app>` | Launch an application using RTX 2050 GPU offload |
| `v` / `vim` | Open Neovim |
| `ff` | Fastfetch system information |
