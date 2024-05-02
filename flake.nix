{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/850f27322239f8cfa56b122cc9a278ab99a49015";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  description = "LimeTea's NixOS config";

  outputs = { self, nixpkgs, home-manager, lanzaboote }: {

    nixosConfigurations = let
      configLib = import ./utils/lib.nix {
        inherit nixpkgs;
        inherit home-manager;
      };
    in configLib.mkConfig {
      systemModules = [
          lanzaboote.nixosModules.lanzaboote
          ./config/packages.nix
          ./config/desktop.nix
          ./config/software.nix
          ./config/misc.nix
      ];
      hosts = {
        "lime-pc" = {
          stateVersion = "24.05";
          systemKind = "x86_64-linux";
          systemConfig = ./config/per-machine/lime-pc.nix;
        };
      };
      users = {
        "lemontea" = {
           groups = [ "wheel" ];
           config = ./config/per-user/lemontea.nix;
        };
      };
    };
  };
}
