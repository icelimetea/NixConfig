{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  description = "LimeTea's NixOS config";

  outputs = { self, nixpkgs }: {

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
                  sway-screen-size = prev.callPackage ./packages/sway-screen-size/default.nix {};
                })
              ];

              nix.nixPath = [ nixpkgsPath ];
	    })
            ./config/main.nix
	    ./config/hardware-configuration.nix
          ];
        };
      }
    );

  };
}
