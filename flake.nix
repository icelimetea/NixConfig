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

    nixosConfigurations = let
      configLib = import ./utils/lib.nix {
        inherit nixpkgs;
        inherit home-manager;
      };
    in configLib.mkConfig {
      "lime-pc" = {
        stateVersion = "22.05";
        systemKind = "x86_64-linux";
        users = { "lemontea" = [ "wheel" ]; };
        hmModules = [ ./modules/doomemacs ];
        systemModules = [
          ({ nixpkgs, ... } : {
            nixpkgs.overlays = [
              (final: prev: { sway-screen-size = prev.callPackage ./packages/sway-screen-size {}; })
            ];
          })
          ./config/desktop.nix
          ./config/software.nix
          ./config/misc.nix
          ./config/hardware-configuration.nix
        ];
      };
    };
  };
}
