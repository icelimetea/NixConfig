{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  description = "LimeTea's NixOS config";

  outputs = { self, nixpkgs, home-manager }: {

    nixosConfigurations = (
      let
        hostName = "lime-pc";
	nixpkgsPath = "nixpkgs=${nixpkgs}";
      in {
        ${hostName} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ({ nixpkgs, ... }: {
	      networking.hostName = hostName;

              system.stateVersion = "21.05";

              nixpkgs.overlays = [
                (final: prev: {
                  sway-screen-size = prev.callPackage ./packages/sway-screen-size {};
                })
              ];

              nix.nixPath = [ nixpkgsPath ];
	    })
            ./config/main.nix
	    ./config/hardware-configuration.nix
	    (home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;

              home-manager.users.lemontea = import ./config/per-user/lemontea.nix
            })
          ];
        };
      }
    );

  };
}
