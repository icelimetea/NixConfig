{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
	    home-manager.nixosModules.home-manager
            ({ nixpkgs, ... }: {
	      networking.hostName = hostName;

              system.stateVersion = "21.05";

              nixpkgs.overlays = [
                (final: prev: {
                  sway-screen-size = prev.callPackage ./packages/sway-screen-size {};
                })
              ];

              nix.nixPath = [ nixpkgsPath ];

              home-manager.useGlobalPkgs = true;

              home-manager.users.lemontea = import ./config/per-user/lemontea.nix;
	    })
	    ./config/desktop.nix
	    ./config/software.nix
            ./config/misc.nix
	    ./config/hardware-configuration.nix
          ];
        };
      }
    );

  };
}
