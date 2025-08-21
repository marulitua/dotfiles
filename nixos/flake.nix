{
  description = "Maruli's NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    nvf = {
#      url = "github:notashelf/nvf";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
  };

#  outputs = inputs@{nixpkgs, home-manager, nvf, ...}: {
  outputs = inputs@{nixpkgs, home-manager, ...}: {
    nixosConfigurations.magnetar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
#        nvf.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.home-manager
  {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.maruli = import ./home.nix;
  }
      ];
    };
  };
}
