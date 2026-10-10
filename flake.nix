{
  description = "Modular NixOS configuration for argon (KDE Plasma 6, Intel + RTX 2050)";

  inputs = {
    # NixOS official package source (unstable provides latest Plasma 6 & drivers)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # System host entry point
          ./hosts/laptop

          # Home Manager as a NixOS module (single unified rebuild command)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.argon = import ./home;
          }
        ];
      };
    };
  };
}
