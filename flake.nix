{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager/935ecea67d59f2af9d9f56d18a8f0dc12fb18cfd";
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

              system.stateVersion = "22.05";

              nixpkgs.overlays = [
                (final: prev: {
                  sway-screen-size = prev.callPackage ./packages/sway-screen-size {};
                })
              ];

              nix = {
	        extraOptions = ''
		  experimental-features = nix-command flakes
                '';

	        nixPath = [ nixpkgsPath ];

                settings = {
		  max-jobs = 2;

                  auto-optimise-store = true;
		};
	      };

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
