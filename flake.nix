{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/c1ff59080e78d6746efc45e624935bcf0fa0a38b";

  description = "LimeTea's NixOS config";

  outputs = { self, nixpkgs }: {

    nixosConfigurations = (
      let
        hostName = "lime-pc";
      in {
        ${hostName} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ({ nixpkgs, ... }: {
	      networking.hostName = hostName;

              system.stateVersion = "21.05";

              nixpkgs.overlays = [
                (final: prev: {
                  sway-screen-size = prev.callPackage ./packages/sway-screen-size/pkg.nix {};
                })
              ];
	    })
            ./config/main.nix
	    ./config/hardware-configuration.nix
          ];
        };
      }
    );

  };
}
