{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/e462c9172c685f0839baaa54bb5b49276a23dab7";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
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
    in configLib.mkConfig ([
          lanzaboote.nixosModules.lanzaboote
          ./config/packages.nix
          ./config/desktop.nix
          ./config/software.nix
          ./config/misc.nix
    ]) ({
      "lime-pc" = {
        stateVersion = "23.05";
        systemKind = "x86_64-linux";
        users = { "lemontea" = [ "wheel" ]; };
      };
    });
  };
}
